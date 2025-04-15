import os
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

@when("I query {collection_name} from the data catalog")
@when("I query {collection_name} from the data catalog with {filter}")
def step_impl(context, collection_name, filter=None):
    s = context.unity_session
    data_manager = s.client(services.DATA_SERVICE)
    print(f"Collection to query is {collection_name}, and optional filter is {filter}")
    cd = data_manager.get_collection_data(Collection(collection_name), filter = filter, limit=100, output_stac = True)
    context.collection_name = collection_name
    context.collection_data = cd


@then("the response has 1 or more granules")
def step_impl(context):
    assert (len(context.collection_data) > 0)


@then("a valid STAC document is returned")
def step_impl(context):
    schemaFileName = get_value(context, 'STAC_SCHEMA_FILE', mandatory=True)
    with open(schemaFileName) as schemaFile:
        schema = json.loads(schemaFile.read())

    try:
        validate(context.collection_data, schema=schema)
    except ValidationError as ve:
        message = f"JSON for {context.collection_name} failed validation for schema {schemaFileName}\n{ve}"
        print(message)
        raise Exception(message)


