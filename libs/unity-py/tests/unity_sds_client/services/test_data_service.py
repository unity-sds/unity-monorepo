import base64

from dotenv import load_dotenv
import os
from unittest import TestCase

from unity_sds_client.services.data_service import DataService
from unity_sds_client.unity import _read_config
from unity_sds_client.unity_environments import UnityEnvironments
from unity_sds_client.unity_session import UnitySession
from unity_sds_client.resources.collection import Collection as UnityCollection


class TestDataService(TestCase):

    def setUp(self) -> None:
        super().setUp()
        load_dotenv()
        os.environ['UNITY_USER'] = base64.standard_b64decode(os.environ.get('USERNAME').encode()).decode()
        os.environ['UNITY_PASSWORD'] = base64.standard_b64decode(os.environ.get('PASSWORD').encode()).decode()

    def test_01(self):
        config = _read_config([os.path.join('..', '..', '..', 'unity_sds_client', 'envs', 'environments.cfg')])
        session = UnitySession(UnityEnvironments.DEV.value, config)
        client = DataService(session=session, endpoint=session.get_unity_href())
        result = client.get_collections(1)
        print(result)
        result = client.get_collections(1, True)
        print(result)
        return

    def test_02(self):
        config = _read_config([os.path.join('..', '..', '..', 'unity_sds_client', 'envs', 'environments.cfg')])
        session = UnitySession(UnityEnvironments.DEV.value, config)
        client = DataService(session=session, endpoint=session.get_unity_href())
        result = client.get_collection_data(UnityCollection('urn:nasa:unity:uds_local_test:DEV1:CHRP_16_DAY_REBIN___9'), 1)
        print(result)
        result = client.get_collection_data(UnityCollection('urn:nasa:unity:uds_local_test:DEV1:CHRP_16_DAY_REBIN___9'), 3, output_stac=True)
        print(result)
        return

    def test_03(self):
        config = _read_config([os.path.join('..', '..', '..', 'unity_sds_client', 'envs', 'environments.cfg')])
        session = UnitySession(UnityEnvironments.DEV.value, config)
        client = DataService(session=session, endpoint=session.get_unity_href())
        result = client.get_collection_data(UnityCollection('urn:nasa:unity:uds_local_test:DEV1:CHRP_16_DAY_REBIN___9'), 1, filter="status = 'completed'", output_stac=True)
        print(result)
        return

    def test_04(self):
        config = _read_config([os.path.join('..', '..', '..', 'unity_sds_client', 'envs', 'environments.cfg')])
        session = UnitySession(UnityEnvironments.DEV.value, config)
        client = DataService(session=session, endpoint=session.get_unity_href())
        client.urn = 'urn'
        client.org = 'nasa'
        client.project = 'unity'
        client.tenant = 'uds_local_test'
        client.tenant_venue = 'DEV1'
        client.collection = 'CHRP_16_DAY_REBIN'
        client.collection_venue = '9'
        result = client.query_custom_properties()
        print(result)
        return

    def test_05(self):
        config = _read_config([os.path.join('..', '..', '..', 'unity_sds_client', 'envs', 'environments.cfg')])
        session = UnitySession(UnityEnvironments.DEV.value, config)
        client = DataService(session=session, endpoint=session.get_unity_href())
        client.urn = 'urn'
        client.org = 'nasa'
        client.project = 'unity'
        client.tenant = 'uds_local_test'
        client.tenant_venue = 'DEV1'
        client.define_custom_metadata({
            'tag': {'type': 'keyword'},
            'c_version': {'type': 'float'},
            'c_type': {'type': 'keyword'},
        })
        return

    def test_06(self):
        config = _read_config([os.path.join('..', '..', '..', 'unity_sds_client', 'envs', 'environments.cfg')])
        session = UnitySession(UnityEnvironments.DEV.value, config)
        client = DataService(session=session, endpoint=session.get_unity_href())
        result = client.create_collection(UnityCollection('urn:nasa:unity:uds_local_test:DEV1:WILLIAM_UNIT_TEST___2'), True)
        print(result)
        return

    def test_07(self):
        config = _read_config([os.path.join('..', '..', '..', 'unity_sds_client', 'envs', 'environments.cfg')])
        session = UnitySession(UnityEnvironments.DEV.value, config)
        client = DataService(session=session, endpoint=session.get_unity_href())
        result = client.delete_collection_item(UnityCollection('urn:nasa:unity:unity:dev:nga-unity-dev-output___3'), 'urn:nasa:unity:unity:dev:nga-unity-dev-output___3:output_1')
        print(result)
        return
