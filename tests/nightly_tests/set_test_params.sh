#!/bin/bash

source ./define_ssm_functions.sh

TESTRAIL_USER_SSM="/unity/cs/testrail/useremail"
export TESTRAIL_USER=$(get_ssm_val "$TESTRAIL_USER_SSM")

TESTRAIL_APIKEY_SSM="/unity/cs/testrail/apikey"
export TESTRAIL_KEY=$(get_ssm_val "$TESTRAIL_APIKEY_SSM")


export BASE_TEST_DIR="`pwd`/../system-tests"
export PYTHONPATH=${BASE_TEST_DIR}:${PYTHONPATH}
export STAC_SCHEMA_FILE="${BASE_TEST_DIR}/support_files/stac.schema.json"
export STAC_COLLECTION_ID="urn:nasa:unity:unity:test:SBG-L2A_CORFL___1"
