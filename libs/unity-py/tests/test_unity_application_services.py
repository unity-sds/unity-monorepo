import pytest
from unity_sds_client.unity import Unity
from unity_sds_client.unity_exception import UnityException
from unity_sds_client.unity_services import UnityServices as Services


@pytest.fixture
def cleanup_update_test():
    yield None
    print("Cleanup...")


def test_app_package_build(mocker):
    mocker.patch(
        "unity_sds_apgs_client.api.DefaultApi.ads_acb_mcp_clone_get",
        return_value={"clone_url": 123, "log": "abc"},
    )
    session = Unity()
    app_service = session.client(Services.APPLICATION_SERVICE)
    response = app_service.build_application_package("my_url")
    assert response["clone_url"] == 123


def test_app_package_build_exception(mocker):
    mocker.patch(
        "unity_sds_apgs_client.api.DefaultApi.ads_acb_mcp_clone_get",
        side_effect=Exception("Service Not Found"),
    )
    session = Unity()
    app_service = session.client(Services.APPLICATION_SERVICE)
    try:
        app_service.build_application_package("my_url")
        assert False
    except UnityException:
        assert True
