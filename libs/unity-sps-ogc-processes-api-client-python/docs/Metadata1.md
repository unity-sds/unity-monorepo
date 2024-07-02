# Metadata1


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**href** | **str** |  |
**hreflang** | **str** |  | [optional]
**rel** | **str** |  | [optional]
**role** | **str** |  | [optional]
**title** | **str** |  | [optional]
**type** | **str** |  | [optional]

## Example

```python
from unity_sps_ogc_processes_api_python_client.models.metadata1 import Metadata1

# TODO update the JSON string below
json = "{}"
# create an instance of Metadata1 from a JSON string
metadata1_instance = Metadata1.from_json(json)
# print the JSON string representation of the object
print(Metadata1.to_json())

# convert the object into a dict
metadata1_dict = metadata1_instance.to_dict()
# create an instance of Metadata1 from a dict
metadata1_from_dict = Metadata1.from_dict(metadata1_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
