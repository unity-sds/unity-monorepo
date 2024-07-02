# unity_sps_ogc_processes_api_python_client.DefaultApi

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**conformance_declaration_conformance_get**](DefaultApi.md#conformance_declaration_conformance_get) | **GET** /conformance | Information about standards that this API conforms to
[**deploy_process_processes_post**](DefaultApi.md#deploy_process_processes_post) | **POST** /processes | Deploy a process
[**dismiss_jobs_job_id_delete**](DefaultApi.md#dismiss_jobs_job_id_delete) | **DELETE** /jobs/{job_id} | Cancel a job execution, remove a finished job
[**execute_processes_process_id_execution_post**](DefaultApi.md#execute_processes_process_id_execution_post) | **POST** /processes/{process_id}/execution | Execute a process
[**get_health_health_get**](DefaultApi.md#get_health_health_get) | **GET** /health | Perform a Health Check
[**job_list_jobs_get**](DefaultApi.md#job_list_jobs_get) | **GET** /jobs | Retrieve the list of jobs
[**landing_page_get**](DefaultApi.md#landing_page_get) | **GET** / | Landing page of this API
[**process_description_processes_process_id_get**](DefaultApi.md#process_description_processes_process_id_get) | **GET** /processes/{process_id} | Retrieve a process description
[**process_list_processes_get**](DefaultApi.md#process_list_processes_get) | **GET** /processes | Retrieve the list of available processes
[**results_jobs_job_id_results_get**](DefaultApi.md#results_jobs_job_id_results_get) | **GET** /jobs/{job_id}/results | Retrieve the result(s) of a job
[**status_jobs_job_id_get**](DefaultApi.md#status_jobs_job_id_get) | **GET** /jobs/{job_id} | Retrieve the status of a job
[**undeploy_process_processes_process_id_delete**](DefaultApi.md#undeploy_process_processes_process_id_delete) | **DELETE** /processes/{process_id} | Undeploy a process


# **conformance_declaration_conformance_get**
> ConfClasses conformance_declaration_conformance_get()

Information about standards that this API conforms to

A list of all conformance classes, specified in a standard, that the server conforms to.  | Conformance class | URI | | -------- | ------- | | Core | http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/core | | OGC Process Description | http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/ogc-process-description | | JSON | http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/json | | HTML | http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/html | | OpenAPI | Specification 3.0       http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/oas30 | | Job list | http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/job-list | | Callback | http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/callback | | Dismiss | http://www.opengis.net/spec/ogcapi-processes-1/1.0/conf/dismiss |  For more information, see [Section 7.4](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_conformance_classes).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.conf_classes import ConfClasses
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)

    try:
        # Information about standards that this API conforms to
        api_response = api_instance.conformance_declaration_conformance_get()
        print("The response of DefaultApi->conformance_declaration_conformance_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->conformance_declaration_conformance_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**ConfClasses**](ConfClasses.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deploy_process_processes_post**
> ProcessOutput deploy_process_processes_post(process_input)

Deploy a process

Deploy a new process.  **Note:** This is not an officially supported endpoint in the OGC Processes specification.

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.process_input import ProcessInput
from unity_sps_ogc_processes_api_python_client.models.process_output import ProcessOutput
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)
    process_input = unity_sps_ogc_processes_api_python_client.ProcessInput() # ProcessInput |

    try:
        # Deploy a process
        api_response = api_instance.deploy_process_processes_post(process_input)
        print("The response of DefaultApi->deploy_process_processes_post:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->deploy_process_processes_post: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **process_input** | [**ProcessInput**](ProcessInput.md)|  |

### Return type

[**ProcessOutput**](ProcessOutput.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |
**422** | Validation Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dismiss_jobs_job_id_delete**
> StatusInfo dismiss_jobs_job_id_delete(job_id)

Cancel a job execution, remove a finished job

Cancel a job execution and remove it from the jobs list.  For more information, see [Section 13](https://docs.ogc.org/is/18-062r2/18-062r2.html#Dismiss).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.status_info import StatusInfo
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)
    job_id = 'job_id_example' # str |

    try:
        # Cancel a job execution, remove a finished job
        api_response = api_instance.dismiss_jobs_job_id_delete(job_id)
        print("The response of DefaultApi->dismiss_jobs_job_id_delete:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->dismiss_jobs_job_id_delete: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **str**|  |

### Return type

[**StatusInfo**](StatusInfo.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |
**422** | Validation Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **execute_processes_process_id_execution_post**
> StatusInfo execute_processes_process_id_execution_post(process_id, execute)

Execute a process

Create a new job.  For more information, see [Section 7.11](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_create_job).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.execute import Execute
from unity_sps_ogc_processes_api_python_client.models.status_info import StatusInfo
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)
    process_id = 'process_id_example' # str |
    execute = unity_sps_ogc_processes_api_python_client.Execute() # Execute |

    try:
        # Execute a process
        api_response = api_instance.execute_processes_process_id_execution_post(process_id, execute)
        print("The response of DefaultApi->execute_processes_process_id_execution_post:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->execute_processes_process_id_execution_post: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **process_id** | **str**|  |
 **execute** | [**Execute**](Execute.md)|  |

### Return type

[**StatusInfo**](StatusInfo.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |
**422** | Validation Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **get_health_health_get**
> HealthCheck get_health_health_get()

Perform a Health Check

Endpoint to perform a healthcheck on. This endpoint can primarily be used Docker to ensure a robust container orchestration and management is in place. Other services which rely on proper functioning of the API service will not deploy if this endpoint returns any other HTTP status code except 200 (OK). Returns:     HealthCheck: Returns a JSON response with the health status

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.health_check import HealthCheck
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)

    try:
        # Perform a Health Check
        api_response = api_instance.get_health_health_get()
        print("The response of DefaultApi->get_health_health_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->get_health_health_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**HealthCheck**](HealthCheck.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Return HTTP Status Code 200 (OK) |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **job_list_jobs_get**
> JobList job_list_jobs_get()

Retrieve the list of jobs

Lists available jobs.  For more information, see [Section 11](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_job_list).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.job_list import JobList
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)

    try:
        # Retrieve the list of jobs
        api_response = api_instance.job_list_jobs_get()
        print("The response of DefaultApi->job_list_jobs_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->job_list_jobs_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**JobList**](JobList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **landing_page_get**
> LandingPage landing_page_get()

Landing page of this API

The landing page provides links to the: - API Definition (no fixed path), - Conformance Statements (`/conformance`), - Processes Metadata (`/processes`), - Endpoint for Job Monitoring (`/jobs`).  For more information, see [Section 7.2](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_landing_page).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.landing_page import LandingPage
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)

    try:
        # Landing page of this API
        api_response = api_instance.landing_page_get()
        print("The response of DefaultApi->landing_page_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->landing_page_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**LandingPage**](LandingPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **process_description_processes_process_id_get**
> ProcessOutput process_description_processes_process_id_get(process_id)

Retrieve a process description

The process description contains information about inputs and outputs and a link to the execution-endpoint for the process. The Core does not mandate the use of a specific process description to specify the interface of a process. That said, the Core requirements class makes the following recommendation:  Implementations SHOULD consider supporting the OGC process description.  For more information, see [Section 7.10](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_process_description).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.process_output import ProcessOutput
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)
    process_id = 'process_id_example' # str |

    try:
        # Retrieve a process description
        api_response = api_instance.process_description_processes_process_id_get(process_id)
        print("The response of DefaultApi->process_description_processes_process_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->process_description_processes_process_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **process_id** | **str**|  |

### Return type

[**ProcessOutput**](ProcessOutput.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |
**422** | Validation Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **process_list_processes_get**
> ProcessList process_list_processes_get()

Retrieve the list of available processes

The list of processes contains a summary of each process the OGC API - Processes offers, including the link to a more detailed description of the process.  For more information, see [Section 7.9](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_process_list).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.process_list import ProcessList
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)

    try:
        # Retrieve the list of available processes
        api_response = api_instance.process_list_processes_get()
        print("The response of DefaultApi->process_list_processes_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->process_list_processes_get: %s\n" % e)
```



### Parameters

This endpoint does not need any parameter.

### Return type

[**ProcessList**](ProcessList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **results_jobs_job_id_results_get**
> object results_jobs_job_id_results_get(job_id)

Retrieve the result(s) of a job

Lists available results of a job. In case of a failure, lists exceptions instead.  For more information, see [Section 7.13](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_retrieve_job_results).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)
    job_id = 'job_id_example' # str |

    try:
        # Retrieve the result(s) of a job
        api_response = api_instance.results_jobs_job_id_results_get(job_id)
        print("The response of DefaultApi->results_jobs_job_id_results_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->results_jobs_job_id_results_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **str**|  |

### Return type

**object**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |
**422** | Validation Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **status_jobs_job_id_get**
> StatusInfo status_jobs_job_id_get(job_id)

Retrieve the status of a job

Shows the status of a job.  For more information, see [Section 7.12](https://docs.ogc.org/is/18-062r2/18-062r2.html#sc_retrieve_status_info).

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.models.status_info import StatusInfo
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)
    job_id = 'job_id_example' # str |

    try:
        # Retrieve the status of a job
        api_response = api_instance.status_jobs_job_id_get(job_id)
        print("The response of DefaultApi->status_jobs_job_id_get:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling DefaultApi->status_jobs_job_id_get: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **str**|  |

### Return type

[**StatusInfo**](StatusInfo.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | Successful Response |  -  |
**422** | Validation Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **undeploy_process_processes_process_id_delete**
> undeploy_process_processes_process_id_delete(process_id, force=force)

Undeploy a process

Undeploy an existing process.  **Note:** This is not an officially supported endpoint in the OGC Processes specification.

### Example

* Bearer (JWT) Authentication (bearerAuth):

```python
import unity_sps_ogc_processes_api_python_client
from unity_sps_ogc_processes_api_python_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost
# See configuration.py for a list of all supported configuration parameters.
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    host = "http://localhost"
)

# The client must configure the authentication and authorization parameters
# in accordance with the API server security policy.
# Examples for each auth method are provided below, use the example that
# satisfies your auth use case.

# Configure Bearer authorization (JWT): bearerAuth
configuration = unity_sps_ogc_processes_api_python_client.Configuration(
    access_token = os.environ["BEARER_TOKEN"]
)

# Enter a context with an instance of the API client
with unity_sps_ogc_processes_api_python_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = unity_sps_ogc_processes_api_python_client.DefaultApi(api_client)
    process_id = 'process_id_example' # str |
    force = False # bool |  (optional) (default to False)

    try:
        # Undeploy a process
        api_instance.undeploy_process_processes_process_id_delete(process_id, force=force)
    except Exception as e:
        print("Exception when calling DefaultApi->undeploy_process_processes_process_id_delete: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **process_id** | **str**|  |
 **force** | **bool**|  | [optional] [default to False]

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**204** | Successful Response |  -  |
**422** | Validation Error |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
