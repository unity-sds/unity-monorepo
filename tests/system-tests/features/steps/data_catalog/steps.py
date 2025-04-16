import os
import requests
import json
from jsonschema import validate, ValidationError

from behave import *  # noqa: F403
from environment import get_value

from unity_sds_client.resources.collection import Collection
from unity_sds_client.resources.dataset import Dataset
from unity_sds_client.resources.data_file import DataFile

from unity_sds_client.unity import Unity
from unity_sds_client.unity import UnityEnvironments
from unity_sds_client.unity_session import UnitySession
from unity_sds_client.unity_services import UnityServices as services

from features.steps.import_steps import *

def _send_request(unity_session, url, filter = None, limit = None):
    token = unity_session._session.get_auth().get_token()
    params = {}
    if limit is not None:
        params["limit"] = limie
    if filter is not None:
        params["filter"] = filter
    return requests.get(url, headers={"Authorization" : "Bearer " + token}, params=(params if len(params) > 0 else None))


@when("I make a get_collection_data call for {collection_name}")
@when("I make a get_collection_data call for {collection_name} with {filter}")
def step_impl(context, collection_name, filter=None):
    s = context.unity_session
    data_manager = s.client(services.DATA_SERVICE)
    print(f"Collection to query is {collection_name}, and optional filter is {filter}")
    cd = data_manager.get_collection_data(Collection(collection_name), filter = filter, limit=100, output_stac = True)
    context.collection_name = collection_name
    context.collection_data = cd


@then("the response has 1 or more granules")
def step_impl(context):
    assert (len(context.collection_data["features"]["assets"]) > 0)


@then("a valid STAC document is returned")
def step_impl(context):
    schema_file_name = get_value(context, 'STAC_SCHEMA_FILE', mandatory=True)
    with open(schema_file_name) as schemaFile:
        schema = json.loads(schemaFile.read())

    try:
        validate(context.collection_data, schema=schema)
    except ValidationError as ve:
        message = f"JSON failed validation for schema {schema_file_name}\n{ve}"
        print(message)
        raise Exception(message)


@when("I make a get items request to the DAPA endpoint at {endpoint} for {collection_name}")
@when("I make a get items request to the DAPA endpoint at {endpoint} for {collection_name} with filter {filter}")
def step_impl(context, endpoint, collection_name, filter=None):
    # Note this is largely verbatim from unity-py's data-service.py implementation of get_collection_data()
    url = endpoint + f'/am-uds-dapa/collections/{collection_name}/items'
    response = _send_request(context.unity_session, url, filter)

    context.collection_data = response.json()


@when("I make a list collections request to the DAPA endpoint at {endpoint}")
def step_impl(context, endpoint):
    url = endpoint + '/am-uds-dapa/collections'
    response = _send_request(context.unity_session, url)

    context.collection_data = response.json()


@then("the response includes one or more collections")
def step_impl(context):
    assert (context.collection_data["numberMatched"] > 0)


@then("each collection has a collection identifier")
def step_impl(context):
    for collection in context.collection_data["features"]:
         assert collection.get("id") is not None
