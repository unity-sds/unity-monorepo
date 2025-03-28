import json
import os
import time
from datetime import datetime

import requests
from behave import *  # noqa: F403
from unity_sds_client.resources.collection import Collection
from unity_sds_client.unity_services import UnityServices as services


@given("the cwl_dag workflow is currently deployed in airflow")  # noqa: F405
def step_impl(context):  # noqa: F811
    deployment_url = os.environ.get("AIRFLOW_ENDPOINT", None)
    if deployment_url is None:
        raise Exception("AIRFLOW_ENDPOINT environment viarble not set. ")
    airflow_user = os.environ.get("AIRFLOW_USER", None)
    airflow_pass = os.environ.get("AIRFLOW_PASS", None)
    dag_id = "cwl_dag"  # This is the generic "run any CWL you want" dag
    response = requests.get(
        url=f"{deployment_url}/api/v1/dags/{dag_id}",
        verify=False,  # Required if not hitting this through a proxy (e.g. mdps.mcp.nasa.gov....)
        auth=(airflow_user, airflow_pass),
        headers={"Content-Type": "application/json"},
    )
    assert response.status_code == 200
    assert response.json()["dag_id"] == "cwl_dag"
    context.airflow_user = airflow_user
    context.airflow_pass = airflow_pass
    context.airflow_endpoint = deployment_url


# This step_impl is specific to the unity-example-application application package
@given(  # noqa: F405
    "I provide the required workflow inputs for unity-example-application"
)  # noqa: F405
def step_impl(context):  # noqa: F811
    # Project/Venue specific items
    project = os.environ.get("PROJECT", None)
    venue = os.environ.get("VENUE", None)
    # We get a datetime to append to the file names we create so we can ensure a _new_ file is added to the system.
    date = datetime.now().strftime("%m%d%YT%H%M%S")
    s3bucket = os.environ.get("VENUE_BUCKET", None)
    output_collection = "urn:nasa:unity:{0}:{1}:unity-tutorial___1".format(
        project, venue
    )
    output_file = "summary_table_{0}.txt".format(date)

    context.output_file = output_file
    context.output_collection = output_collection
    input_json = """
    {{
      "stage_in": {{
        "stac_json": "https://raw.githubusercontent.com/unity-sds/unity-tutorial-application/main/test/stage_in/stage_in_results.json",
        "downloading_roles": "",
        "downloading_keys": "data",
        "download_type": "HTTP",
        "edl_username": null,
        "edl_password_type": "",
        "edl_password": "",
        "unity_client_id": "",
        "unity_stac_auth": "NONE"
      }},
      "parameters": {{
        "output_collection": "urn:nasa:unity:{0}:{1}:unity-tutorial___1",
        "summary_table_filename": "summary_table_{2}.txt"
      }},
      "stage_out": {{
        "staging_bucket": "{3}",
        "collection_id": "urn:nasa:unity:{0}:{1}:unity-tutorial___1",
        "result_path_prefix": "stage_out"
      }}
    }}
    """.format(
        project, venue, date, s3bucket
    )
    context.cwl_args = input_json


@when("I request a run of {workflow_name} from {workflow_location}")  # noqa: F405
def step_impl(context, workflow_name, workflow_location):  # noqa: F811
    dag_id = "cwl_dag"  # This is the generic "run any CWL you want" dag
    response = requests.post(
        url=f"{context.airflow_endpoint}/api/v1/dags/{dag_id}/dagRuns",
        verify=False,  # Required if not hitting this through a proxy (e.g. mdps.mcp.nasa.gov....)
        auth=(context.airflow_user, context.airflow_pass),
        headers={"Content-Type": "application/json"},
        data="""{{
        "conf":{{
            "cwl_args": {0},
            "cwl_workflow":"{1}"
            }}
        }}""".format(
            json.dumps(str(json.loads(context.cwl_args))), workflow_location
        ),
    )
    context.response = response
    dag_run_id = response.json()["dag_run_id"]
    context.dag_run_id = dag_run_id


@then("the workflow is executed successfully")  # noqa: F405
def step_impl(context):  # noqa: F811
    assert context.response.status_code == 200


@then("the workflow successfully completes")  # noqa: F405
def step_impl(context):  # noqa: F811
    dag_id = "cwl_dag"  # This is the generic "run any CWL you want" dag
    state = "running"
    while state == "running" or state == "queued":
        dag_run_response = requests.get(
            url=f"{context.airflow_endpoint}/api/v1/dags/{dag_id}/dagRuns/{context.dag_run_id}",
            verify=False,  # Required if not hitting this through a proxy (e.g. mdps.mcp.nasa.gov....)
            auth=(context.airflow_user, context.airflow_pass),
            headers={"Content-Type": "application/json"},
        )
        state = dag_run_response.json()["state"]
        print("Dag run state is {}".format(state))
        time.sleep(30)
    assert state == "success"


@then("the workflow data shows up in the data catalog")  # noqa: F405
def step_impl(context):  # noqa: F811
    s = context.unity_session
    data_manager = s.client(services.DATA_SERVICE)
    collection_id = context.output_collection
    found = False
    check = 1
    print("finding data for collection {}".format(collection_id))
    while found is False and check < 20:
        cd = data_manager.get_collection_data(Collection(collection_id), limit=100)
        for dataset in cd:
            if context.output_file in dataset.id:
                found = True
                break
        check = check + 1
        time.sleep(30)

    assert found is True
