# ProcessOutput


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**description** | **str** |  | [optional]
**id** | **str** |  |
**inputs** | [**List[InputValueOutput]**](InputValueOutput.md) |  | [optional]
**job_control_options** | [**List[JobControlOptions]**](JobControlOptions.md) |  | [optional]
**keywords** | **List[str]** |  | [optional]
**links** | [**List[Link]**](Link.md) |  | [optional]
**metadata** | [**List[Metadata]**](Metadata.md) |  | [optional]
**outputs** | [**List[InputValueOutput]**](InputValueOutput.md) |  | [optional]
**title** | **str** |  | [optional]
**version** | **str** |  |

## Example

```python
from unity_sps_ogc_processes_api_python_client.models.process_output import ProcessOutput

# TODO update the JSON string below
json = "{}"
# create an instance of ProcessOutput from a JSON string
process_output_instance = ProcessOutput.from_json(json)
# print the JSON string representation of the object
print(ProcessOutput.to_json())

# convert the object into a dict
process_output_dict = process_output_instance.to_dict()
# create an instance of ProcessOutput from a dict
process_output_from_dict = ProcessOutput.from_dict(process_output_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)
