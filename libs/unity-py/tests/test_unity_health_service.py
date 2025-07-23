"""
This module contains a set of tests is to ensure that the
Unity Health Service is functional.
"""

from unittest.mock import patch, Mock

import json
import pytest

from unity_sds_client.unity import Unity
from unity_sds_client.unity_environments import UnityEnvironments
from unity_sds_client.unity_services import UnityServices
from jsonschema import validate


@pytest.mark.regression
def test_health_status_schema():
    """
    Test that Health API schema is valid
    """
    print("Validate Health API Schema")

    mock_data_file_path = 'tests/test_files/health_api_mock_data.json'
    schema_file_path = '../../schemas/health-service/health-services.schema.json'

    with open(mock_data_file_path, encoding='utf-8') as f_mock_data, \
         open(schema_file_path, encoding='utf-8') as f_health_schema:
        mock_health_data = json.load(f_mock_data)
        schema = json.load(f_health_schema)
        validate(instance=mock_health_data, schema=schema)

@pytest.mark.regression
def test_health_status_printing():
    """
    Test that health statuses can be printed using the health service.
    """
    s = Unity(environment=UnityEnvironments.DEV)
    s.set_project("unity")
    s.set_venue("dev")
    health_service = s.client(UnityServices.HEALTH_SERVICE)

    print("Example health status output using health service object:")

    mock_data_file_path = 'tests/test_files/health_api_mock_data.json'
    with open(mock_data_file_path, encoding='utf-8') as f_mock_data:
        mock_get_patcher = patch('unity_sds_client.services.health_service.requests.get')
        mock_get = mock_get_patcher.start()
        mock_get.return_value = Mock(status_code = 200)
        mock_get.return_value.json.return_value = json.load(f_mock_data)
        health_service.print_health_status()

@pytest.mark.regression
def test_health_service_printing():
    """
    Test that health statuses can be printed using the unity object
    """
    s = Unity(environment=UnityEnvironments.DEV)
    s.set_project("unity")
    s.set_venue("dev")

    print("Example health status output using unity object:")
    mock_data_file_path = 'tests/test_files/health_api_mock_data.json'
    with open(mock_data_file_path, encoding='utf-8') as f_mock_data:
        mock_get_patcher = patch('unity_sds_client.services.health_service.requests.get')
        mock_get = mock_get_patcher.start()
        mock_get.return_value = Mock(status_code = 200)
        mock_get.return_value.json.return_value = json.load(f_mock_data)
        print(s)
