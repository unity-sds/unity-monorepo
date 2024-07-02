# Subscriber


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**failed_uri** | **str** |  | [optional]
**in_progress_uri** | **str** |  | [optional]
**success_uri** | **str** |  |

## Example

```python
from unity_sps_ogc_processes_api_python_client.models.subscriber import Subscriber

# TODO update the JSON string below
json = "{}"
# create an instance of Subscriber from a JSON string
subscriber_instance = Subscriber.from_json(json)
# print the JSON string representation of the object
print(Subscriber.to_json())

# convert the object into a dict
subscriber_dict = subscriber_instance.to_dict()
# create an instance of Subscriber from a dict
subscriber_from_dict = Subscriber.from_dict(subscriber_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
