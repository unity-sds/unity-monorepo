# LandingPage


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**attribution** | **str** |  | [optional]
**description** | **str** |  | [optional]
**links** | [**List[Link]**](Link.md) |  |
**title** | **str** |  | [optional]

## Example

```python
from unity_sps_ogc_processes_api_python_client.models.landing_page import LandingPage

# TODO update the JSON string below
json = "{}"
# create an instance of LandingPage from a JSON string
landing_page_instance = LandingPage.from_json(json)
# print the JSON string representation of the object
print(LandingPage.to_json())

# convert the object into a dict
landing_page_dict = landing_page_instance.to_dict()
# create an instance of LandingPage from a dict
landing_page_from_dict = LandingPage.from_dict(landing_page_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
