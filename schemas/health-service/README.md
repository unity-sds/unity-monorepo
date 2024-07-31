## What is the Health Check Monitoring System?

The health check monitoring system is a system deployed to each project/venue deployment in an AWS account.
It periodically checks a set of defined endpoints, and stores the results of what was healthy (or not) in a JSON file, in a S3 bucket.
There is a REST API that is also deployed that can be queried to return the gathered health information.
UIs can leverage this information to display the current state of the system. 
The health check information has the added benefit of also providing information about what the landing page URLs are for each Unity component.

## Where are the Health Check Endpoints defined?

The set of "healthCheck" endpoints will be defined by what's in AWS SSM.
Unity components will have a corresponding SSM parameter starting with:
* `/unity/${project}/${venue}/component/` for project/venue components, and
* `/unity/shared-services/component/` for shared services components.

For example: `/unity/europa/dev/component/management-console` for a Management Console deployed in the `europa` project, `dev` venue.
or `/unity/shared-services/component/data-catalog` for the Data Catalog in the shared services account.

## What is the format of the SSM value?

The value should be a JSON-formatted value containing `componentName`, `healthCheckUrl`, and `landingPageUrl`.

For example:
```
{
    "componentName": "Airflow UI",
    "healthCheckUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000/health",
    "landingPageUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000",
}
```

## Who Creates the SSM entries?

The Service Areas (or sometimes U-CS) are responsible for creating the SSM entries.

If the deployment occurs via the Management Console/Marketplace then the deployment infrastructure as code (IAC, usually terraform) will be responsible for creating the SSM values.
Otherwise the SSM entry can be created manually in the venue.  Creating these SSM parameters automatically, as part of a component deployment is obviously preferable.

## How does the querying occur?

A lambda function periodically fires off (nominally every 5 minutes, leveraging AWS EventBridge) and:

1) queries SSM for all params starting with:
`/unity/${PROJECT}/${VENUE}/component`
or
`/unity/shared-services/component`  
NOTE: The latter form of shared SSM parameters are created per [these instructions](https://unity-sds.gitbook.io/docs/developer-docs/common-services/docs/users-guide/deployment/shared-services-deployment).

2) gathers the health status of each of the healthCheck URLs found in the SSM values. For now, HTTP 200 represents HEALTHY, and anything else represents UNHEALTHY. Some of the URLs represented in the SSM values are endpoints in the shared services AWS account, and others are in the venue account.
Generates the JSON status file, with the statuses (healthy or unhealthy). EXAMPLE JSON file:
{
  "services": [
    {
        "componentName": "Data Catalog",
        "ssmKey": "/unity/component/shared-services/data-catalog",
        "healthCheckUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000/health",
        "landingPageUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000",
        "healthChecks": [
            {
                "status": "HEALTHY",
                "httpResponseCode": "200",
                "date": "2024-07-08T20:03:34.429305"
            }
        ]
    },
    {
        "componentName": "Jupyter",
        "ssmKey": "/unity/component/shared-services/data-catalog",
        "healthCheckUrl": "https://unity.com/project/venue/ads/jupyter/health-check",
        "landingPageUrl": "https://unity.com/project/venue/ads/jupyter",
        "healthChecks": [
            {
                "status": "UNHEALTHY",
                "httpResponseCode": "403",
                "date": "2024-07-08T20:03:34.429305"
            }
        ]
    }
  ]
}

3) Uploads JSON file to S3 bucket. Use the bucket defined in Create SSM parameter for monitoring S3 bucket name #370


## What if the healthCheck endpoint is secured? How will I work around that?

@mike-gangl mentions that there is a methodology for getting the username/password from SSM, then getting a token.
See https://github.com/unity-sds/unity-data-services/blob/develop/cumulus_lambda_functions/lib/cognito_login/cognito_token_retriever.py for an example of how U-DS gets a token.that's getting the cognito login and then something like https://github.com/unity-sds/unity-data-services/blob/develop/cumulus_lambda_functions/stage_in_out/dapa_client.py uses that cognito token to make calls.
See also: https://github.com/unity-sds/sounder-sips-tutorial/blob/develop/jupyter-notebooks/tutorials/2_working_with_data.ipynb

## How are the results of the periodic checks retrieved?

There is an endpoint, that is part of the Management Console, that can be queried, to retrieve the results as a JSON file.  This server endpoint is deployed for each venue.  For example, for the `unity/dev` project/venue deployment, the service can be found at:
https://www.dev.mdps.mcp.nasa.gov:4443/unity/dev/management/api/health_checks

The response of this, looks something like this:
```
{
    "services": [
        {
            "componentName": "Airflow API",
            "ssmKey": "/unity/unity/dev/component/luca/airflow-api",
            "healthCheckUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000/api/v1/health",
            "landingPageUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000/api/v1",
            "healthChecks": [
                {
                    "status": "HEALTHY",
                    "httpResponseCode": "200",
                    "date": "2024-07-26T07:29:21.316116"
                }
            ]
        },
        {
            "componentName": "Airflow UI",
            "ssmKey": "/unity/unity/dev/component/luca/airflow-ui",
            "healthCheckUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000/health",
            "landingPageUrl": "http://k8s-airflow-airflowi-c68f394a2a-1712638265.us-west-2.elb.amazonaws.com:5000",
            "healthChecks": [
                {
                    "status": "HEALTHY",
                    "httpResponseCode": "200",
                    "date": "2024-07-26T07:29:21.363497"
                }
            ]
        },
        {
            "componentName": "OGC API",
            "ssmKey": "/unity/unity/dev/component/luca/ogc-api",
            "healthCheckUrl": "http://k8s-airflow-ogcproce-e84448018d-906922971.us-west-2.elb.amazonaws.com:5001/health",
            "landingPageUrl": "http://k8s-airflow-ogcproce-e84448018d-906922971.us-west-2.elb.amazonaws.com:5001",
            "healthChecks": [
                {
                    "status": "HEALTHY",
                    "httpResponseCode": "200",
                    "date": "2024-07-26T07:29:21.395126"
                }
            ]
        },
    ]
}
```
