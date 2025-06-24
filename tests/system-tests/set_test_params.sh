#!/bin/bash

source ../nightly_tests/define_ssm_functions.sh

SSM_PREFIX="/${PROJECT}/${VENUE}/system-test"

# ---------------------------------------
# Posting slack results
# ---------------------------------------
SLACK_WEB_HOOK_URL_SSM="${SSM_PREFIX}/slack-web-hook-url"
SLACK_URL_VAL=$(get_ssm_val "$SLACK_WEB_HOOK_URL_SSM")


# ---------------------------------------
# Testrail
# ---------------------------------------
if [[ "$USE_TESTRAIL" == "true" ]]; then
  TESTRAIL_USER_SSM="${SSM_PREFIX}/testrail/useremail"
  export TESTRAIL_USER=$(get_ssm_val "$TESTRAIL_USER_SSM")

  TESTRAIL_APIKEY_SSM="${SSM_PREFIX}/testrail/apikey"
  export TESTRAIL_KEY=$(get_ssm_val "$TESTRAIL_APIKEY_SSM")
fi


# ---------------------------------------
# Unity
# ---------------------------------------
UNITY_ENVIRONMENT_SSM="${SSM_PREFIX}/environment"
export UNITY_ENVIRONMENT=$(get_ssm_val "$UNITY_ENVIRONMENT_SSM")

UNITY_USER_SSM="${SSM_PREFIX}/user"
export UNITY_USER=$(get_ssm_val "$UNITY_USER_SSM")

UNITY_PASSWORD_SSM="${SSM_PREFIX}/password"
export UNITY_PASSWORD=$(get_ssm_val "$UNITY_PASSWORD_SSM")

UNITY_AIRFLOW_ENDPOINT_SSM="${SSM_PREFIX}/airflow-endpoint"
export AIRFLOW_ENDPOINT=$(get_ssm_val "$UNITY_AIRFLOW_ENDPOINT_SSM")

VENUE_BUCKET_SSM="${SSM_PREFIX}/venue-bucket"
export VENUE_BUCKET=$(get_ssm_val "$VENUE_BUCKET_SSM")

DOCKSTORE_API_SSM="${SSM_PREFIX}/dockstore/api"
export DOCKSTORE_API=$(get_ssm_val "$DOCKSTORE_API_SSM")

DOCKSTORE_TOKEN_SSM="${SSM_PREFIX}/dockstore/token"
export DOCKSTORE_TOKEN=$(get_ssm_val "$DOCKSTORE_TOKEN_SSM")


# ---------------------------------------
# Test runtime
# ---------------------------------------
export BASE_TEST_DIR="`pwd`"
export PYTHONPATH=${BASE_TEST_DIR}:${PYTHONPATH}
