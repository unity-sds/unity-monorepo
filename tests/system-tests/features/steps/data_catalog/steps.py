import datetime
import os
import requests
import json

import boto3

import pystac

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

# utility function to send a request to a given DAPA endpoint
def _send_request(unity_session, url, filter = None, limit = None):
    token = unity_session._session.get_auth().get_token()
    params = {}
    if limit is not None:
        params['limit'] = limie
    if filter is not None:
        params['filter'] = filter
    response = requests.get(url, headers={"Authorization" : "Bearer " + token}, params=(params if len(params) > 0 else None))

    # dump the response on error
    print(f"{response.json()}")
    return response


# utility function to issue a collections/{collection_name}/items request
def _get_items_for_collection(context, endpoint, collection_name, filter = None):
    url = endpoint + f"/am-uds-dapa/collections/{collection_name}/items"
    response = _send_request(context.unity_session, url, filter)
    return response.json()


@given("I authenticate with AWS")
def step_impl(context):  # noqa: F403
    sts_client = boto3.client('sts')
    caller_identity = sts_client.get_caller_identity()
    print(f"AWS caller identity: {caller_identity}")
    context.sts_client = sts_client


@when("I make a get_collection_data call for {collection_name}")
@when("I make a get_collection_data call for {collection_name} with {filter}")
def step_impl(context, collection_name, filter=None):  # noqa: F403
    s = context.unity_session
    data_manager = s.client(services.DATA_SERVICE)
    print(f"Collection to query is {collection_name}, and optional filter is {filter}")
    cd = data_manager.get_collection_data(Collection(collection_name), filter = filter, limit=100, output_stac = True)
    context.collection_name = collection_name
    context.collection_data = cd


@when("I make a get items request to the DAPA endpoint at {endpoint} for {collection_name}")
@when("I make a get items request to the DAPA endpoint at {endpoint} for {collection_name} with filter {filter}")
def step_impl(context, endpoint, collection_name, filter=None):  # noqa: F403
    response = _get_items_for_collection(context, endpoint, collection_name, filter)
    context.collection_name = collection_name
    context.collection_data = response


@when("I make a datetime filtered get items request to the DAPA endpoint at {endpoint} for {collection_name} with {beginning_date} and {ending_date}")
def step_impl(context, endpoint, collection_name, beginning_date, ending_date):  # noqa: F403
    filter = f"datetime >= '{beginning_date}' and datetime <= '{ending_date}'"
    response = _get_items_for_collection(context, endpoint, collection_name, filter)
    context.collection_name = collection_name
    context.collection_data = response


@when("I make a list collections request to the DAPA endpoint at {endpoint}")
def step_impl(context, endpoint):  # noqa: F403
    url = endpoint + '/am-uds-dapa/collections'
    response = _send_request(context.unity_session, url)
    context.collection_data = response.json()


@then("the response specifies a set of valid STAC collection items")
def step_impl(context):  # noqa: F403
    failure_present = False
    for each_feature in context.collection_data['features']:
        try:
            pystac.Item.from_dict(each_feature).validate()
        except pystac.STACError as se:
            print(f"Item id : {each_feature.get('id')} STAC Error\n{se}")
            failure_present = True
        except pystac.STACValidationError as ve:
            print(f"Item id : {each_feature.get('id')} failed STAC validation\n{ve}")
            failure_present = True
    if failure_present:
        raise Exception("One or more items failed STAC validation.")


@then("the response specifies a set of valid STAC collections")
def step_impl(context):  # noqa: F403
    failure_present = False
    for each_collection in context.collection_data['features']:
        try:
            pystac.Collection.from_dict(each_collection).validate()
        except pystac.STACError as se:
            print(f"Collection id : {each_collection.get('id')} STAC Error\n{se}")
            failure_present = True
        except pystac.STACValidationError as ve:
            print(f"Collection id : {each_collection.get('id')} failed STAC validation\n{ve}")
            failure_present = True
    if failure_present:
        raise Exception("One or more collections failed STAC validation.")


@then("the response includes one or more collections")
def step_impl(context):  # noqa: F403
    print(context.collection_data)
    assert (context.collection_data.get('numberMatched') is not None and context.collection_data['numberMatched'] > 0)


@then("the response includes one or more granules")
def step_impl(context):  # noqa: F403
    assert (len(context.collection_data['features']) > 0)


@then("each granule in the response has a temporal extent")
def step_impl(context):  # noqa: F403
    features = context.collection_data['features']
    for feature in features:
        properties = feature.get('properties')
        start_datetime = properties.get('start_datetime') if properties is not None else None
        end_datetime = properties.get('end_datetime') if properties is not None else None
        assert(start_datetime is not None and end_datetime is not None)


@then("each granule in the response has one or more data access links")
def step_impl(context):  # noqa: F403
    features = context.collection_data['features']
    for feature in features:
        assets = feature['assets']
        for asset_id, asset_metadata in assets.items():
            href = asset_metadata.get('href')
            assert(href is not None)


@then("each collection in the response has a collection identifier")
def step_impl(context):  # noqa: F403
    for feature in context.collection_data['features']:
         assert feature.get('id') is not None


@then("each granule in the response is within the range of {beginning_date} and {ending_date}")
def step_impl(context, beginning_date, ending_date):  # noqa: F403
    features = context.collection_data['features']
    beginning_datetime = datetime.strptime(beginning_date, "%Y-%m-%dT%H:%M:%SZ")
    ending_datetime = datetime.strptime(ending_date, "%Y-%m-%dT%H:%M:%SZ")
    for feature in features:
        properties = feature.get('properties')
        datetime_str = properties.get('datetime') if properties is not None else None
        assert(datetime_str is not None)

        feature_datetime = datetime.strptime(datetime_str, "%Y-%m-%dT%H:%M:%S.%fZ")
        assert(feature_datetime >= beginning_datetime and feature_datetime <= ending_datetime)


@then("the object is downloaded from S3 via the data access link in the response")
def step_impl(context):  #noqa: F403
    s3_client = boto3.client('s3')
    features = context.collection_data['features']
    for feature in features:
        assets = feature['assets']
        for asset_id, asset_metadata in assets.items():
            hrefs = asset_metadata.get('href')
            assert(hrefs is not None)
            if isinstance(hrefs, str):
                hrefs = [hrefs]
            assert(len(hrefs) > 0)
            for href in hrefs:
                if href.startswith('s3://'):
                    bucket,object_key = href[5:].split('/',maxsplit=1)
                    head_info = s3_client.head_object(Bucket=bucket,Key=object_key)
