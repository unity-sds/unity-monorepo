# InputValueInput


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**bbox** | **List[object]** |  |
**crs** | [**Crs**](Crs.md) |  | [optional]

## Example

```python
from unity_sps_ogc_processes_api_python_client.models.input_value_input import InputValueInput

# TODO update the JSON string below
json = "{}"
# create an instance of InputValueInput from a JSON string
input_value_input_instance = InputValueInput.from_json(json)
# print the JSON string representation of the object
print(InputValueInput.to_json())

# convert the object into a dict
input_value_input_dict = input_value_input_instance.to_dict()
# create an instance of InputValueInput from a dict
input_value_input_from_dict = InputValueInput.from_dict(input_value_input_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
