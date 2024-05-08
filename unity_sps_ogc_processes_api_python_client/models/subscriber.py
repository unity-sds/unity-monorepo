# coding: utf-8

"""
    Unity Processing API conforming to the OGC API - Processes - Part 1 standard

    This document is an API definition document provided alongside the OGC API - Processes standard. The OGC API - Processes Standard specifies a processing interface to communicate over a RESTful protocol using JavaScript Object Notation (JSON) encodings. The specification allows for the wrapping of computational tasks into executable processes that can be offered by a server and be invoked by a client application.

    The version of the OpenAPI document: 1.0.0
    Generated by OpenAPI Generator (https://openapi-generator.tech)

    Do not edit the class manually.
"""  # noqa: E501


from __future__ import annotations
import pprint
import re  # noqa: F401
import json

from pydantic import BaseModel, ConfigDict, Field
from typing import Any, ClassVar, Dict, List, Optional
from typing_extensions import Annotated
from typing import Optional, Set
from typing_extensions import Self

class Subscriber(BaseModel):
    """
    Subscriber
    """ # noqa: E501
    success_uri: Annotated[str, Field(min_length=1, strict=True)] = Field(alias="successUri")
    in_progress_uri: Optional[Annotated[str, Field(min_length=1, strict=True)]] = Field(default=None, alias="inProgressUri")
    failed_uri: Optional[Annotated[str, Field(min_length=1, strict=True)]] = Field(default=None, alias="failedUri")
    __properties: ClassVar[List[str]] = ["successUri", "inProgressUri", "failedUri"]

    model_config = ConfigDict(
        populate_by_name=True,
        validate_assignment=True,
        protected_namespaces=(),
    )


    def to_str(self) -> str:
        """Returns the string representation of the model using alias"""
        return pprint.pformat(self.model_dump(by_alias=True))

    def to_json(self) -> str:
        """Returns the JSON representation of the model using alias"""
        # TODO: pydantic v2: use .model_dump_json(by_alias=True, exclude_unset=True) instead
        return json.dumps(self.to_dict())

    @classmethod
    def from_json(cls, json_str: str) -> Optional[Self]:
        """Create an instance of Subscriber from a JSON string"""
        return cls.from_dict(json.loads(json_str))

    def to_dict(self) -> Dict[str, Any]:
        """Return the dictionary representation of the model using alias.

        This has the following differences from calling pydantic's
        `self.model_dump(by_alias=True)`:

        * `None` is only added to the output dict for nullable fields that
          were set at model initialization. Other fields with value `None`
          are ignored.
        """
        excluded_fields: Set[str] = set([
        ])

        _dict = self.model_dump(
            by_alias=True,
            exclude=excluded_fields,
            exclude_none=True,
        )
        # set to None if in_progress_uri (nullable) is None
        # and model_fields_set contains the field
        if self.in_progress_uri is None and "in_progress_uri" in self.model_fields_set:
            _dict['inProgressUri'] = None

        # set to None if failed_uri (nullable) is None
        # and model_fields_set contains the field
        if self.failed_uri is None and "failed_uri" in self.model_fields_set:
            _dict['failedUri'] = None

        return _dict

    @classmethod
    def from_dict(cls, obj: Optional[Dict[str, Any]]) -> Optional[Self]:
        """Create an instance of Subscriber from a dict"""
        if obj is None:
            return None

        if not isinstance(obj, dict):
            return cls.model_validate(obj)

        _obj = cls.model_validate({
            "successUri": obj.get("successUri"),
            "inProgressUri": obj.get("inProgressUri"),
            "failedUri": obj.get("failedUri")
        })
        return _obj


