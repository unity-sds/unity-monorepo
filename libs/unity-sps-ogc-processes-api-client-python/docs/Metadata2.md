# Metadata2


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lang** | **str** |  | [optional]
**role** | **str** |  | [optional]
**title** | **str** |  | [optional]
**value** | [**Value**](Value.md) |  | [optional]

## Example

```python
from unity_sps_ogc_processes_api_python_client.models.metadata2 import Metadata2

# TODO update the JSON string below
json = "{}"
# create an instance of Metadata2 from a JSON string
metadata2_instance = Metadata2.from_json(json)
# print the JSON string representation of the object
print(Metadata2.to_json())

# convert the object into a dict
metadata2_dict = metadata2_instance.to_dict()
# create an instance of Metadata2 from a dict
metadata2_from_dict = Metadata2.from_dict(metadata2_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
