#!/bin/bash

source ./define_ssm_functions.sh

# ---------------------------------------
# Common
# ---------------------------------------
TESTRAIL_USER_SSM="/unity/cs/testrail/useremail"
export TESTRAIL_USER=$(get_ssm_val "$TESTRAIL_USER_SSM")

TESTRAIL_APIKEY_SSM="/unity/cs/testrail/apikey"
export TESTRAIL_KEY=$(get_ssm_val "$TESTRAIL_APIKEY_SSM")

# ---------------------------------------
# Project/Venue specific
# ---------------------------------------
SSM_PREFIX="/${PROJECT_NAME}/${VENUE_NAME}"

# TBD, these might be generated as part of the deployment:
# AIRFLOW_ENDPOINT
# VENUE_BUCKET

UNITY_ENVIRONMENT_SSM="${SSM_PREFIX}/environment"
export UNITY_ENVIRONMENT=$(get_ssm_val "$UNITY_ENVIRONMENT_SSM")

UNITY_USER_SSM="${SSM_PREFIX}/user"
export UNITY_USER=$(get_ssm_val "$UNITY_USER_SSM")

UNITY_PASSWORD_SSM="${SSM_PREFIX}/password"
export UNITY_PASSWORD=$(get_ssm_val "$UNITY_PASSWORD_SSM")

# DOCKSTORE_API_SSM="${SSM_PREFIX}/dockstore/api"
# export DOCKSTORE_API=$(get_ssm_val "$DOCKSTORE_API_SSM")

# DOCKSTORE_TOKEN_SSM="${SSM_PREFIX}/dockstore/token"
# export DOCKSTORE_TOKEN=$(get_ssm_val "$DOCKSTORE_TOKEN_SSM")

# AIRFLOW_USER_SSM="${SSM_PREFIX}/airflow/user"
# export AIRFLOW_USER=$(get_ssm_val "$AIRFLOW_USER_SSM")

# AIRFLOW_PASS_SSM="${SSM_PREFIX}/airflow/pass"
# export AIRFLOW_PASS=$(get_ssm_val "$AIRFLOW_PASS_SSM")

# ---------------------------------------
# Test runtime
# ---------------------------------------
export BASE_TEST_DIR="`pwd`/../system-tests"
export PYTHONPATH=${BASE_TEST_DIR}:${PYTHONPATH}
