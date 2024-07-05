# coding: utf-8

"""
    Unity Processing API conforming to the OGC API - Processes - Part 1 standard

    This document is an API definition document provided alongside the OGC API - Processes standard. The OGC API - Processes Standard specifies a processing interface to communicate over a RESTful protocol using JavaScript Object Notation (JSON) encodings. The specification allows for the wrapping of computational tasks into executable processes that can be offered by a server and be invoked by a client application.

    The version of the OpenAPI document: 1.0.0
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501


import unittest

from unity_sps_ogc_processes_api_python_client.models.validation_error_loc_inner import (
    ValidationErrorLocInner,
)


class TestValidationErrorLocInner(unittest.TestCase):
    """ValidationErrorLocInner unit test stubs"""

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def make_instance(self, include_optional) -> ValidationErrorLocInner:
        """Test ValidationErrorLocInner
        include_option is a boolean, when False only required
        params are included, when True both required and
        optional params are included"""
        # uncomment below to create an instance of `ValidationErrorLocInner`
        """
        model = ValidationErrorLocInner()
        if include_optional:
            return ValidationErrorLocInner(
            )
        else:
            return ValidationErrorLocInner(
        )
        """

    def testValidationErrorLocInner(self):
        """Test ValidationErrorLocInner"""
        # inst_req_only = self.make_instance(include_optional=False)
        # inst_req_and_optional = self.make_instance(include_optional=True)


if __name__ == "__main__":
    unittest.main()