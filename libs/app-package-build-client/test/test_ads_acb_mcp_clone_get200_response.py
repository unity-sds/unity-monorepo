# coding: utf-8

"""
    App Package API

    Service for application package generation

    The version of the OpenAPI document: 1.0.0
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501


import unittest

from unity_sds_apgs_client.models.ads_acb_mcp_clone_get200_response import (
    AdsAcbMcpCloneGet200Response,
)


class TestAdsAcbMcpCloneGet200Response(unittest.TestCase):
    """AdsAcbMcpCloneGet200Response unit test stubs"""

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def make_instance(self, include_optional) -> AdsAcbMcpCloneGet200Response:
        """Test AdsAcbMcpCloneGet200Response
        include_optional is a boolean, when False only required
        params are included, when True both required and
        optional params are included"""
        # uncomment below to create an instance of `AdsAcbMcpCloneGet200Response`
        """
        model = AdsAcbMcpCloneGet200Response()
        if include_optional:
            return AdsAcbMcpCloneGet200Response(
                clone_url = '',
                log_group_name = ''
            )
        else:
            return AdsAcbMcpCloneGet200Response(
        )
        """

    def testAdsAcbMcpCloneGet200Response(self):
        """Test AdsAcbMcpCloneGet200Response"""
        # inst_req_only = self.make_instance(include_optional=False)
        # inst_req_and_optional = self.make_instance(include_optional=True)


if __name__ == "__main__":
    unittest.main()
