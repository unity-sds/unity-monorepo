import os
from behave_testrail_reporter import TestrailReporter

"""
Make sure these agree with those utilized in 
https://github.com/unity-sds/unity-cs-infra/nightly_tests/run.sh
"""
VENUE_VARNAME = "VENUE_NAME"
BRANCH_VARNAME = "GH_BRANCH"
TESTRAIL_VARNAME = "TESTRAIL"

DEFAULT_VENUE = "test"
VALUE_YES = "yes"
VALUE_NO = "no"


"""
The code within the before_all() function is run prior to any test steps are run.
This is a great place to instantiate any of class objects and store them as attributes 
in behave's context object for later use.
"""
def before_all(context):
    # The following creates an api_calls attribute for behave's context object
    context.venue = get_value(context, VENUE_VARNAME, default=DEFAULT_VENUE)

    # See if testrail integration is specfied, if so, activate it
    check_and_set_testrail(context)


"""
If testrail integration is desired by specifying a command line or enviornmental
argument 'TESTRAIL=yes", set up the testrail reporter. It is assumed that a
testrail.yml exists in the project root and TESTRAIL_USER and TESTRAIL_KEY 
environment variables are appropriately set. 
"""
def check_and_set_testrail(context):
    if get_value(context, TESTRAIL_VARNAME, default=VALUE_NO).lower() == VALUE_YES:
        gh_branch = get_value(context, BRANCH_VARNAME, mandatory=True)
        testrail_reporter = TestrailReporter(gh_branch)
        context.config.reporters.append(testrail_reporter)


"""
function that attempts to acquire the run-time value of a variable first from 
the context config's userdata (i.e. command line specified) then the environment. 
Returns the indicated default if neither specifies a value, or raises an exception 
if the mandatory flag is set.
"""
def get_value(context, var_name, default=None, mandatory=False):
    value = context.config.userdata.get(var_name)
    if value is None:
        value = os.environ.get(var_name, default)

    if mandatory and value is None:
        raise Exception(f"Variable {var_name} is mandatory but no value was provided.")

    return value
