#!/bin/bash

USE_TESTRAIL=No
PROJECT_NAME=""
VENUE_NAME=""
GH_BRANCH="main"
DEPLOYMENT_START_TIME=$(date +%s)

# Function to display usage instructions
usage() {
    echo "Usage: $0 --project-name <PROJECT_NAME> --venue-name <VENUE_NAME> --log-dir <LOCAL_LOG_DIR> [--log-s3-path <LOG_S3_PATH>] [--testrail <true|false>] [--repo-branch <branch>]"
    exit 1
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --testrail)
            case "$2" in
                true)
                    USE_TESTRAIL=Yes
                    ;;
                false)
                    USE_TESTRAIL=No
                    ;;
                *)
                    echo "Invalid argument for --testrail. Please specify 'true' or 'false'." >&2
                    exit 1
                    ;;
            esac
            shift 2
            ;;
        --project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --venue-name)
            VENUE_NAME="$2"
            shift 2
            ;;
        --log-dir)
            LOG_DIR="$2"
            shift 2
            ;;
        --log-s3-path)
            LOG_S3_PATH="$2"
            shift 2
            ;;
        --repo-branch)
            GH_BRANCH="$2"
            shift 2
            ;;
        *)
            echo "Invalid option: $1" >&2
            exit 1
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
if [[ -z $LOG_DIR ]]; then
    usage
fi


# Install python3-pip
sudo apt update
sudo apt install -y python3-pip

# Install boto3 if not installed
pip3 list | grep boto3 > out.txt
if ! grep -q boto3 out.txt; then
    echo "Installing boto3..."
    pip3 install boto3
fi

rm out.txt

echo "RUN ARGUMENTS: "
echo "  - Use testrail?                   $USE_TESTRAIL"
echo "  - Project Name:                   $PROJECT_NAME"
echo "  - Venue Name:                     $VENUE_NAME"
echo "  - Github Branch :                 $GH_BRANCH"
echo "---------------------------------------------------------"

export GH_BRANCH="${GH_BRANCH}"
TODAYS_DATE=$(date '+%F_%H-%M')

# set up gherkin/behave environment
source ./set_test_params.sh

#
# Check values are set
#
if [ -z "$SLACK_URL_VAL" ] ; then 
    echo "ERROR: Could not read Slack URL from SSM." ; exit 1
fi
if [ -z "$AIRFLOW_ENDPOINT" ] ; then
    echo "ERROR: Could not read Airflow endpoint from SSM." ; exit 1
fi

mkdir -p ${LOG_DIR}

# update self (unity-monorepo repository)
git pull origin ${GH_BRANCH}
git checkout ${GH_BRANCH}

# Install behave if not installed
pip3 list | grep "behave " > out.txt
if ! grep -q "behave " out.txt; then
  echo "Installing behave..."
  pip3 install behave
fi

# Install behave-testrail-reporter if needed and not installed
pip3 list | grep "behave-testrail-reporter" > out.txt
if ! grep -q "behave-testrail-reporter" out.txt; then
  echo "Installing behave-testrail-reporter..."
  pip3 install behave-testrail-reporter
fi

rm out.txt

# Start the timer
start_time=$(date +%s)

echo "Running BDD tests..."

# run gherkin/behave tests
source ${BASE_TEST_DIR}/regression_test.sh &> behave_nightly_output.txt

# End the timer
end_time=$(date +%s)

# Calculate the duration
duration=$((end_time - start_time))

rm -f behave_summary.txt
echo -e "\n\nBDD Summary: " >> behave_summary.txt
tail -4 behave_nightly_output.txt | grep "passed, " >> behave_summary.txt
tail -4 behave_nightly_output.txt | grep "Took " >> behave_summary.txt
echo -e "\n\n" >> behave_summary.txt

# extract out the meaningful but brief snippets of the behave output
BDD_SUMMARY="BDD SUMMARY:\n$(tail -4 behave_nightly_output.txt)\n------------------------------------------\n\n\n"
BDD_OUTPUT="${BDD_SUMMARY}$(grep -E 'Feature: |'\
'Scenario: |'\
'Scenario Outline: |'\
'^Failing scenarios:$|'\
'^[0-9]+ feature[s]* passed, |'\
'^[0-9]+ scenario[s]* passed, |'\
'^[0-9]+ step[s]* passed, |'\
'^Took [0-9.]+m[0-9.]+s$|'\
':[0-9]+  [A-Za-z0-9., !?]*(--) \@[0-9.]+ endpoints$'\
        behave_nightly_output.txt)"

BDD_OUTPUT=$(echo -e "${BDD_OUTPUT}")
  
mv behave_nightly_output.txt ${LOG_DIR}

# Push the output logs/screenshots to S3 for review/auditing purposesa
if [[ -n $LOG_S3_PATH ]]; then
  echo "Pushing test results to ${LOG_S3_PATH}..."
  if aws s3 cp ${LOG_DIR} ${LOG_S3_PATH}/${LOG_DIR} --recursive; then
    echo "Test results successfully pushed to S3."
  fi
fi

# Post results to Slack
curl_output=$(curl -X POST -H 'Content-type: application/json' \
  --data \
    '{
       "bdd_summary" : "'"${BDD_OUTPUT}"'",
       "bdd_output_url" : "'"${LOG_S3_PATH}/${LOG_DIR}/behave_nightly_output.txt"'"
     }' \
  ${SLACK_URL_VAL})

echo "Curl response: ${curl_output}"

# prune older log directories
BASE_LOG_DIR=./system_test_logs
find "$BASE_LOG_DIR" -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec echo "Deleting directory: {}" \; -exec rm -r {} \;

