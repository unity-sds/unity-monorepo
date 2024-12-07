#!/bin/bash

source ./define_ssm_functions.sh

# 
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

echo "set_deployment_ssm_params.sh :: PROJECT_NAME: ${PROJECT_NAME}"
echo "set_deployment_ssm_params.sh :: VENUE_NAME: ${VENUE_NAME}"

#
# Create SSM:
# /unity/deployment/<PROJECT_NAME>/<VENUE_NAME>/project-name
#
PROJECT_NAME_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/project-name"
PROJECT_NAME_VAL="${PROJECT_NAME}"
refresh_ssm_param "${PROJECT_NAME_SSM}" "${PROJECT_NAME_VAL}" "management" "todo" "console" \
 "${PROJECT_NAME}-${VENUE_NAME}-cs-management-projectNameSsm"

#
# Create SSM:
# /unity/deployment/<PROJECT_NAME>/<VENUE_NAME>/venue-name
#
VENUE_NAME_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/venue-name"
VENUE_NAME_VAL="${VENUE_NAME}"
refresh_ssm_param "${VENUE_NAME_SSM}" "${VENUE_NAME_VAL}" "management" "todo" "console" \
"${PROJECT_NAME}-${VENUE_NAME}-cs-management-venueNameSsm"

#
# Create SSM:
# /unity/deployment/<PROJECT_NAME>/<VENUE_NAME>/status
#
DEPLOYMENT_STATUS_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/deployment/status"
DEPLOYMENT_STATUS_VAL="deploying"
refresh_ssm_param "${DEPLOYMENT_STATUS_SSM}" "${DEPLOYMENT_STATUS_VAL}" "management" "todo" "console" \
"${PROJECT_NAME}-${VENUE_NAME}-cs-management-deploymentStatusSsm"

# Create SSM:
# /unity/${project}/${venue}/cs/monitoring/s3/bucketName
#
S3_HEALTH_CHECK_NAME_SSM="/unity/${PROJECT_NAME}/${VENUE_NAME}/cs/monitoring/s3/bucketName"
S3_HEALTH_CHECK_NAME_VAL="unity-${PROJECT_NAME}-${VENUE_NAME}-bucket"
refresh_ssm_param "${S3_HEALTH_CHECK_NAME_SSM}" "${S3_HEALTH_CHECK_NAME_VAL}" "management" "todo" "console" \
"${PROJECT_NAME}-${VENUE_NAME}-cs-management-S3HealthCheckBucketNameSsm"
