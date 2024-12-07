#!/bin/bash

# =================================================================
# This script deletes SSM params that are specific to a deployment
# =================================================================

PROJECT_NAME=""
VENUE_NAME=""

# Function to display usage instructions
usage() {
    echo "Usage: $0 --project-name <PROJECT_NAME> --venue-name <VENUE_NAME>"
    exit 1
}

#
# It's mandatory to speciy a valid command arguments
#
if [[ $# -ne 4 ]]; then
  usage
fi

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --venue-name)
            VENUE_NAME="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

# Check if mandatory options are provided
if [[ -z $PROJECT_NAME ]]; then
    usage
fi
if [[ -z $VENUE_NAME ]]; then
    usage
fi

echo "destroy_deployment_ssm_params.sh :: PROJECT_NAME: ${PROJECT_NAME}"
echo "destroy_deployment_ssm_params.sh :: VENUE_NAME: ${VENUE_NAME}"

#
# Sub-routine to gracefully delete a SSM parameter
#
delete_ssm_param() {
    local key=$1
    echo "Deleting SSM parameter: ${key} ..."
    local lookup=$(aws ssm get-parameter --name "$key" 2>&1)
    if [[ "$(echo "${lookup}" | grep -q "ParameterNotFound" && echo no)" == "no" ]]; then
        echo "SSM param ${key} not found.  Not attempting a delete."
    else
        aws ssm delete-parameter --name "${key}" || echo "ERROR: SSM delete failed for $key"
    fi
}

#
# Delete SSM:
# /unity/deployment/<PROJECT_NAME>/<VENUE_NAME>/project-name
#
PROJECT_NAME_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/project-name"
PROJECT_NAME_VAL="${PROJECT_NAME}"
delete_ssm_param "${PROJECT_NAME_SSM}"

#
# Delete SSM:
# /unity/deployment/<PROJECT_NAME>/<VENUE_NAME>/venue-name
#
VENUE_NAME_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/venue-name"
VENUE_NAME_VAL="${VENUE_NAME}"
delete_ssm_param "${VENUE_NAME_SSM}"

#
# Delete SSM:
# /unity/deployment/<PROJECT_NAME>/<VENUE_NAME>/status
#
DEPLOYMENT_STATUS_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/deployment/status"
DEPLOYMENT_STATUS_VAL="deploying"
delete_ssm_param "${DEPLOYMENT_STATUS_SSM}"

# Delete SSM:
# /unity/${project}/${venue}/cs/monitoring/s3/bucketName
#
S3_HEALTH_CHECK_NAME_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/cs/monitoring/s3/bucketName"
S3_HEALTH_CHECK_NAME_VAL="${PROJECT_NAME}-${VENUE_NAME}-monitoring-bucket"

delete_ssm_param "${S3_HEALTH_CHECK_NAME_SSM}"
