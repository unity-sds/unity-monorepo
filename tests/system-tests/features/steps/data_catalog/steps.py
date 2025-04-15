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

@when("a collection lookup request is made to the DAPA endpoint")
def step_impl(context):
    s = context.unity_session
    dataManager = s.client(services.DATA_SERVICE)

    collection_id = get_value(context, 'COLLECTION_ID', mandatory=True)
    print(f"Collection to manipulate is {collection_id}")
    context.collection_data = dataManager.get_collection_data(Collection(collection_id), output_stac = True, limit=100, filter="updated >= '2024-03-18T00:00:00Z' and updated <= '2024-03-21T23:59:59Z'")

@then("a valid STAC document is returned")
def step_impl(context):
    schemaFileName = get_value(context, 'STAC_SCHEMA_FILE', mandatory=True)
    with open(schemaFileName) as schemaFile:
        schema = json.loads(schemaFile.read())

    try:
        validate(context.collection_data, schema=schema)
    except ValidationError as ve:
        message = f"JSON for {get_value(context, 'COLLECTION_ID', mandatory=True)} failed validation for schema {schemaFileName}\n{ve}"
        print(message)
        raise Exception(message)



