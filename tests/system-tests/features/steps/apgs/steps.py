import os
import time

from behave import step_registry
from unity_sds_apgs_client.models import AdsAcbMcpCloneGet200Response
from unity_sds_client.services.application_service import DockstoreAppCatalog
from unity_sds_client.unity import Unity, UnityEnvironments
from unity_sds_client.unity_services import UnityServices as services


@step_registry.given("I have a token to authenticate with Unity Services")
def step_impl(context):  # noqa: F811
    if "develop" in context.tags:
        s = Unity(UnityEnvironments.DEV)
    elif "test" in context.tags:
        s = Unity(UnityEnvironments.TEST)
    elif "prod" in context.tags:
        s = Unity(UnityEnvironments.PROD)
    else:
        raise Exception(
            "no environment included as a run tag. Expected one of [develop, test, prod]"
        )

    context.unity_session = s
    # Forces the authorization to occur and get a token.
    token = s._session.get_auth().get_token()
    if token is None:
        raise Exception("Unable to get a token from the unity environment")


@step_registry.when("I submit {repo_name} to the apgs build system")
def step_impl(context, repo_name):  # noqa: F811
    # Find existing version of the package on dockstore:
    dockstore_api = os.environ.get("DOCKSTORE_API", None)
    dockstore_token = os.environ.get("DOCKSTORE_TOKEN", None)
    if dockstore_token is None or dockstore_api is None:
        raise Exception("Dockstore API and/or Credentials are not set.")
    app_catalog = DockstoreAppCatalog(dockstore_api, dockstore_token)
    dockstore_app = os.path.basename(repo_name)
    print("Searching for {}".format(dockstore_app))
    for app in app_catalog.application_list(published=True):
        print(app.name, app.source_repository)
        if app.name == dockstore_app and "sarkissian" in app.source_repository:
            default_version = app.dockstore_info["defaultVersion"]
            print("Found existing version " + str(default_version))
            break
    context.app_version = default_version

    context.repo_name = repo_name
    s = context.unity_session
    app_service = s.client(services.APPLICATION_SERVICE)
    print("Submitting {} to apgs".format(repo_name))
    response = app_service.build_application_package(repo_name)
    context.response = response


@step_registry.then("the apgs build response is success")
def step_impl(context):  # noqa: F811
    response = context.response
    assert isinstance(response, AdsAcbMcpCloneGet200Response)
    assert response.clone_url == context.repo_name


@step_registry.then("I wait for the apgs build to complete")
def step_impl(context):  # noqa: F811
    dockstore_api = os.environ.get("DOCKSTORE_API", None)
    dockstore_token = os.environ.get("DOCKSTORE_TOKEN", None)
    if dockstore_token is None or dockstore_api is None:
        raise Exception("Dockstore API and/or Credentials are not set.")
    app_catalog = DockstoreAppCatalog(dockstore_api, dockstore_token)

    defaultVersion = context.app_version

    check = 0
    print("Existing application version: " + str(context.app_version))
    while defaultVersion == context.app_version and check < 20:
        time.sleep(30)
        dockstore_app = os.path.basename(context.repo_name)
        for app in app_catalog.application_list(published=True):
            if app.name == dockstore_app and "sarkissian" in app.source_repository:
                defaultVersion = app.dockstore_info["defaultVersion"]
        print("Found default version " + str(defaultVersion))
        check = check + 1

    if defaultVersion == context.app_version:
        raise Exception("defaultVersion was the same after 10 minutes. Failing test")
