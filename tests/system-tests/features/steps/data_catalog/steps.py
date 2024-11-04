import os

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

# TODO: Change the call such that a STAC document is returned.
@when("a collection lookup request is made to the DAPA endpoint")
def step_impl(context):
    s = context.unity_session
    dataManager = s.client(services.DATA_SERVICE)

    collection_id = get_value(context, 'COLLECTION_ID', mandatory=True)
    print(f"Collection to manipulate is {collection_id}")
    context.collection_data = dataManager.get_collection_data(Collection(collection_id), limit=100, filter="updated >= '2024-03-18T00:00:00Z' and updated <= '2024-03-21T23:59:59Z'")

# TODO: Change this to validity of the returned STAC document.
@then("one and only one collection is returned")
def step_impl(context):
    print(f'I have received {len(context.collection_data)} collections.')
    for dataset in context.collection_data:
        print(f'dataset begin time: {dataset.data_begin_time}')
        print(f'dataset end time: {dataset.data_end_time}')
        print(f'dataset id: {dataset.id}' )
    if (len(context.collection_data) < 1):
        raise Exception("No result collection has been returned.")
    if (len(context.collection_data) > 1):
        raise Exception("More than one result collection has been returned.")

