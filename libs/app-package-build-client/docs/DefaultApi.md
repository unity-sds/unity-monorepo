# unity_sds_apgs_client.DefaultApi

All URIs are relative to *http://api.dev.mdps.mcp.nasa.gov*

Method | HTTP request | Description
------------- | ------------- | -------------
[**ads_acb_mcp_clone_get**](DefaultApi.md#ads_acb_mcp_clone_get) | **GET** /ads-acb/mcp-clone | Begins the MCP Clone process


# **ads_acb_mcp_clone_get**
> AdsAcbMcpCloneGet200Response ads_acb_mcp_clone_get(clone_url)

Begins the MCP Clone process

### Example

* Bearer Authentication (bearerAuth):

```python
import unity_sds_apgs_client
from unity_sds_apgs_client.models.ads_acb_mcp_clone_get200_response import AdsAcbMcpCloneGet200Response
from unity_sds_apgs_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://api.dev.mdps.mcp.nasa.gov
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sds_apgs_client.Configuration(
    host = "http://api.dev.mdps.mcp.nasa.gov"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization: bearerAuth
configuration = unity_sds_apgs_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sds_apgs_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sds_apgs_client.DefaultApi(api_client)
    clone_url = 'clone_url_example' # str |

    try:
        # Begins the MCP Clone process
        api_response = api_instance.ads_acb_mcp_clone_get(clone_url)
        print("The response of DefaultApi->ads_acb_mcp_clone_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->ads_acb_mcp_clone_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clone_url** | **str**|  |

### Return type

[**AdsAcbMcpCloneGet200Response**](AdsAcbMcpCloneGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successfully submitted a job |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
