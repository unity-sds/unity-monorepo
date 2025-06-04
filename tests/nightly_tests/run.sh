#!/bin/bash

DESTROY=""
RUN_TESTS=""
RUN_BDD_TEST=false
USE_TESTRAIL=No
PROJECT_NAME=""
VENUE_NAME=""
LATEST=""
MC_VERSION="null"
GH_BRANCH="main"
DEPLOYMENT_START_TIME=$(date +%s)
MC_SHA="null"
LOG_S3_PATH=""
CONFIG_FILE="marketplace_config.yaml"  # Set default config file
MONITORING_LAMBDA_VERSION=""
APIGATEWAY_VERSION=""
PROXY_VERSION=""
UI_VERSION=""
# Function to display usage instructions
# TODO: refine the command line selection of tests, e.g. use behave tags for BDD testing and implicit tags for other (e.g. selenium) testing
usage() {
    echo "Usage: $0 --destroy <true|false> --run-tests <true|false> --project-name <PROJECT_NAME> --venue-name <VENUE_NAME> [--log-s3-path <LOG_S3_PATH>] [--mc-version <MC_VERSION>] [--mc-sha <MC_SHA>] [--config-file <CONFIG_FILE>] [--run-bdd-tests <true|false>] [--testrail <true|false>] [--repo-branch <branch>]"
    echo "    --run-bdd-tests and --run-tests are independent from one another. But --testrail is considered only if --run-bbd-tests is active. Default for both --run-bdd-tests and --testrail are false."
    exit 1
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        --destroy)
            case "$2" in
                true)
                    DESTROY=true
                    ;;
                false)
                    DESTROY=false
                    ;;
                *)
                    echo "Invalid argument for --destroy. Please specify 'true' or 'false'." >&2
                    exit 1
                    ;;
            esac
            shift 2
            ;;
        --run-tests)
            case "$2" in
                true)
                    RUN_TESTS=true
                    ;;
                false)
                    RUN_TESTS=false
                    ;;
                *)
                    echo "Invalid argument for --run-tests. Please specify 'true' or 'false'." >&2
                    exit 1
                    ;;
            esac
            shift 2
            ;;
        --run-bdd-tests)
            case "$2" in
                true)
                    RUN_BDD_TESTS=true
                    ;;
                false)
                    RUN_BDD_TESTS=false
                    ;;
                *)
                    echo "Invalid argument for --run-bdd-tests. Please specify 'true' or 'false'." >&2
                    exit 1
                    ;;
            esac
            shift 2
            ;;
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
        --log-s3-path)
            LOG_S3_PATH="$2"
            shift 2
            ;;
        --mc-version)
            MC_VERSION="$2"
            shift 2
            ;;
        --config-file)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --repo-branch)
            GH_BRANCH="$2"
            shift 2
            ;;
        --latest)
            LATEST="true"
            MC_VERSION="latest"
            MONITORING_LAMBDA_VERSION="latest"
            APIGATEWAY_VERSION="latest"
            PROXY_VERSION="latest"
            UI_VERSION="latest"
            shift 1
            ;;
        --mc-sha)
            MC_SHA="$2"
            shift 2
            ;;
        --unity-cs-monitoring-lambda-version)
            MONITORING_LAMBDA_VERSION="$2"
            shift 2
            ;;
        --unity-apigateway-version)
            APIGATEWAY_VERSION="$2"
            shift 2
            ;;
        --unity-proxy-version)
            PROXY_VERSION="$2"
            shift 2
            ;;
        --unity-portal-version)
            UI_VERSION="$2"
            shift 2
            ;;
        *)
            echo "Invalid option: $1" >&2
            exit 1
            ;;
    esac
done

# Check if mandatory options are provided
if [[ -z $DESTROY ]]; then
    usage
fi
if [[ -z $RUN_TESTS ]]; then
    usage
fi
if [[ -z $PROJECT_NAME ]]; then
    usage
fi
if [[ -z $VENUE_NAME ]]; then
    usage
fi

#
# Does a deployment already exist for this project/venue?
# If so, then don't continue with this deployment,
# warn the user, and bail out.
#
echo "Checking for existing deployment for (project=${PROJECT_NAME}, venue=${VENUE_NAME}) ..."
aws ssm get-parameter --name "/unity/${PROJECT_NAME}/${VENUE_NAME}/deployment/status" 2>ssm_lookup.txt
if grep -q "ParameterNotFound" ssm_lookup.txt; then
    echo "Existing deployment not found.  Continuing with deployment..."
    rm ssm_lookup.txt
elif grep -q "ExpiredTokenException" ssm_lookup.txt; then
    echo "ERROR: AWS credentials have expired or are invalid. Please renew and restart."
    rm ssm_lookup.txt
    exit 1
else
    echo "ERROR: A deployment appears to already exist for project=${PROJECT_NAME}, venue=${VENUE_NAME}."
    echo "       Please cleanup the resources for this deployment, before continuing!"
    rm ssm_lookup.txt
    exit 1
fi

# Install python3-pip
sudo apt update
sudo apt install -y python3-pip

# Install packages required for selenium tests
#
# Install pytest if not installed
pip3 list | grep pytest > out.txt
if ! grep -q pytest out.txt; then
    echo "Installing pytest..."
    pip3 install pytest
fi

# Install boto3 if not installed
pip3 list | grep boto3 > out.txt
if ! grep -q boto3 out.txt; then
    echo "Installing boto3..."
    pip3 install boto3
fi

# Install selenium if not installed
pip3 list | grep selenium > out.txt
if ! grep -q selenium out.txt; then
    echo "Installing selenium..."
    pip3 install selenium
fi

# Install jq if not installed - this is used to escape any JSON embedded within the Slack data
pip3 list | grep jq > out.txt
if ! grep -q jq out.txt; then
    echo "Installing jq..."
    pip3 install jq
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Installing yq..."
    sudo snap install yq
fi

rm out.txt

echo "RUN ARGUMENTS: "
echo "  - Destroy stack at end of script? $DESTROY"
echo "  - Run tests?                      $RUN_TESTS"
echo "  - Run BDD tests?                  $RUN_BDD_TESTS"
echo "  - Use testrail?                   $USE_TESTRAIL"
echo "  - Project Name:                   $PROJECT_NAME"
echo "  - Venue Name:                     $VENUE_NAME"
echo "  - MC Version:                     $MC_VERSION"
echo "  - MC SHA:                         $MC_SHA"
echo "  - Config File:                    $CONFIG_FILE"
echo "  - Github Branch :                 $GH_BRANCH"

echo "---------------------------------------------------------"

export MC_SHA="${MC_SHA}"
export STACK_NAME="unity-management-console-${PROJECT_NAME}-${VENUE_NAME}"
export GH_BRANCH="${GH_BRANCH}"
TODAYS_DATE=$(date '+%F_%H-%M')
LOG_DIR=nightly_logs/log_${TODAYS_DATE}

#
# Create common SSM params
#
source ./set_common_ssm_params.sh
export MC_INSTANCETYPE_VAL="${MC_INSTANCETYPE_VAL}"
export CS_PRIVILEGED_POLICY_NAME_VAL="${CS_PRIVILEGED_POLICY_NAME_VAL}"
export GITHUB_USERNAME_VAL="${GITHUB_USERNAME_VAL}"
export GITHUB_USEREMAIL_VAL="${GITHUB_USEREMAIL_VAL}"
export GITHUB_TOKEN_VAL="${GITHUB_TOKEN_VAL}"
export SLACK_URL_VAL="${SLACK_URL_VAL}"
export VPC_ID_VAL="${VPC_ID_VAL}"
export SUBNET_LIST_VAL="${SUBNET_LIST_VAL}"
export PUB_SUBNET_1_VAL="${PUB_SUBNET_1_VAL}"
export PUB_SUBNET_2_VAL="${PUB_SUBNET_2_VAL}"
export PRIV_SUBNET_1_VAL="${PRIV_SUBNET_1_VAL}"
export PRIV_SUBNET_2_VAL="${PRIV_SUBNET_2_VAL}"
export EKS_AMI_25_VAL="${EKS_AMI_25_VAL}"
export EKS_AMI_26_VAL="${EKS_AMI_26_VAL}"
export EKS_AMI_27_VAL="${EKS_AMI_27_VAL}"

#
# Check values are set
#
if [ -z "$GITHUB_TOKEN_VAL" ] ; then
    echo "ERROR: Could not read Github Token from SSM." ; exit 1
fi
if [ -z "$SLACK_URL_VAL" ] ; then 
    echo "ERROR: Could not read Slack URL from SSM." ; exit 1
fi
if [ -z "$GITHUB_USERNAME_VAL" ] ; then 
    echo "ERROR: Could not read Github username from SSM." ; exit 1
fi
if [ -z "$GITHUB_USEREMAIL_VAL" ] ; then 
    echo "ERROR: Could not read Github user email from SSM." ; exit 1
fi

#cd ../aws_role_create
#./create_roles_and_policies.sh
#cd ../nightly_tests

#
# Make sure git is properly setup
#
git config --global user.email ${GITHUB_USEREMAIL_VAL}
git config --global user.name ${GITHUB_USERNAME_VAL}
git remote set-url origin https://oauth2:${GITHUB_TOKEN_VAL}@github.com/unity-sds/unity-monorepo.git

rm -f nightly_output.txt
rm -f cloudformation_events.txt
mkdir -p ${LOG_DIR}

NIGHTLY_HASH=$(git rev-parse --short HEAD)
echo "Repo Hash (Nightly Test):     [$NIGHTLY_HASH]" >> nightly_output.txt
echo "Repo Hash (Nightly Test):     [$NIGHTLY_HASH]"
echo "Management Console Version:        [$MC_VERSION]"
echo "Management Console SHA:        [$MC_SHA]"

## update self (unity-monorepo repository)
git pull origin ${GH_BRANCH}
git checkout ${GH_BRANCH}

#
# Deploy the Management Console using CloudFormation
#
bash deploy.sh --stack-name "${STACK_NAME}" --project-name "${PROJECT_NAME}" --venue-name "${VENUE_NAME}" --mc-version "${MC_VERSION}" --config-file "$CONFIG_FILE" --mc-sha "$MC_SHA" ${LATEST:+--latest} ${MONITORING_LAMBDA_VERSION:+--unity-cs-monitoring-lambda-version "$MONITORING_LAMBDA_VERSION"} ${APIGATEWAY_VERSION:+--unity-apigateway-version "$APIGATEWAY_VERSION"} ${PROXY_VERSION:+--unity-proxy-version "$PROXY_VERSION"} ${UI_VERSION:+--unity-portal-version "$UI_VERSION"}

echo "Deploying Management Console..." >> nightly_output.txt
echo "Deploying Management Console..."

# Start the timer
start_time=$(date +%s)


aws cloudformation describe-stack-events --stack-name ${STACK_NAME} >> cloudformation_events.txt

sleep 400

# Get MC URL from SSM (Management Console populates this value)
export SSM_MC_URL="/unity/${PROJECT_NAME}/${VENUE_NAME}/management/httpd/loadbalancer-url"
echo "SSM Parameter Name: ${SSM_MC_URL}"

# Get the raw SSM parameter value and print it
RAW_SSM_VALUE=$(aws ssm get-parameter --name ${SSM_MC_URL} --query "Parameter.Value" --output text)

export MANAGEMENT_CONSOLE_URL="${RAW_SSM_VALUE}"
echo "Management Console URL: ${MANAGEMENT_CONSOLE_URL}"

# Extract just the hostname with debug prints
STEP1=$(echo $MANAGEMENT_CONSOLE_URL | sed 's|^http://||' | sed 's|^HTTP://||')

STEP2=$(echo $STEP1 | cut -d':' -f1)

ALB_HOST=$(echo $STEP2 | cut -d'/' -f1)

echo "Updating Apache configuration in S3..."

# Create venue path from project and venue name
VENUE_PATH="/${PROJECT_NAME}/${VENUE_NAME}/"

# Create temporary files
TEMP_CONFIG_FILE="/tmp/venue_config.txt"
TEMP_FULL_CONFIG="/tmp/unity-cs.conf"

# Create the Apache configuration block with markers
cat << EOF > $TEMP_CONFIG_FILE

    # ---------- BEGIN ${PROJECT_NAME}/${VENUE_NAME} ----------
    # ${PROJECT_NAME}/${VENUE_NAME}
    #
    Define VENUE_ALB_HOST ${ALB_HOST}
    Define VENUE_ALB_PORT 8080
    Define VENUE_ALB_PATH ${VENUE_PATH}
    RewriteEngine On
    RewriteCond %{HTTP:Connection} Upgrade [NC]
    RewriteCond %{HTTP:Upgrade} websocket [NC]
    RewriteCond %{REQUEST_URI} "\${VENUE_ALB_PATH}"
    RewriteRule \${VENUE_ALB_PATH}(.*) ws://\${VENUE_ALB_HOST}:\${VENUE_ALB_PORT}\${VENUE_ALB_PATH}\$1 [P,L] [END]
    <Location "\${VENUE_ALB_PATH}">
       ProxyPreserveHost on
       AuthType openid-connect
       Require valid-user

       # Added to point to httpd within the venue account
       ProxyPass "http://\${VENUE_ALB_HOST}:\${VENUE_ALB_PORT}\${VENUE_ALB_PATH}"
       ProxyPassReverse "http://\${VENUE_ALB_HOST}:\${VENUE_ALB_PORT}\${VENUE_ALB_PATH}"
       RequestHeader     set "X-Forwarded-Proto" expr=%{REQUEST_SCHEME}
       RequestHeader     set "X-Forwarded-Host" "www.dev.mdps.mcp.nasa.gov:4443"
    </Location>
    # ---------- END ${PROJECT_NAME}/${VENUE_NAME} ----------

EOF

# Get environment from SSM
export ENV_SSM_PARAM="/unity/account/venue"
ENVIRONMENT=$(aws ssm get-parameter --name ${ENV_SSM_PARAM} --query "Parameter.Value" --output text )
echo "Environment from SSM: ${ENVIRONMENT}"

# Use environment in S3 bucket name
S3_BUCKET="ucs-shared-services-apache-config-${ENVIRONMENT}"

# Download current config from S3
aws s3 cp s3://${S3_BUCKET}/unity-cs.conf $TEMP_FULL_CONFIG

# Insert new config before </VirtualHost>
sed -i "/<\/VirtualHost>/e cat $TEMP_CONFIG_FILE" $TEMP_FULL_CONFIG

# Upload updated config back to S3
if aws s3 cp $TEMP_FULL_CONFIG s3://${S3_BUCKET}/unity-cs.conf; then
    echo "Successfully updated Apache configuration in S3"
else
    echo "Failed to update Apache configuration in S3"
    exit 1
fi

# Clean up temporary files
rm $TEMP_CONFIG_FILE
rm $TEMP_FULL_CONFIG

if [[ "$RUN_TESTS" == "true" ]]; then
  echo "Checking if Docker is installed..."
  #
  # Check if Docker is installed
  #
  if ! command -v docker &> /dev/null; then
    echo "Docker not installed. Installing Docker..."

    # Add Docker's official GPG key
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    # Install Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
    sleep 10

    echo "Docker installed successfully."
  else
    echo "Docker already installed [OK]"
  fi

  sudo docker pull selenium/standalone-chrome
  echo "Launching selenium docker..."
  CONTAINER_ID=$(sudo docker run -d -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome)
  sleep 10

  cp nightly_output.txt testing_nightly_output.txt
else
  echo "Not checking if docker is installed (--run-tests false)."
fi # END IF RUN-TESTS

#
# Wait until a succesful HTTP code is being returned
# from the load balancer, indicating the Management Console is accessible
#
interval=10  # polling interval in seconds
max_attempts=50
attempt=1
while [ $attempt -le $max_attempts ]; do
    response_code=$(curl -s -o /dev/null -w "%{http_code}" "$MANAGEMENT_CONSOLE_URL")
    if [[ $response_code =~ ^[2-3][0-9]{2}$ ]]; then
        echo "Success! HTTP response code $response_code received."
        break
    else
        echo "Attempt $attempt to reach Management Console via httpd -- Received HTTP response code $response_code. Retrying in $interval seconds..."
        sleep $interval
        ((attempt++))
    fi
done
# End the timer
end_time=$(date +%s)

# Calculate the duration
duration=$((end_time - start_time))

# MC Creation Time
echo "Management Console Creation Time: $duration seconds"
echo "Management Console Creation Time: $duration seconds" >> nightly_output.txt


# SSM Creation, CloudFormation, Bootstrap time
DEPLOYMENT_END_TIME=$(date +%s)
DEPLOYMENT_DURATION=$((DEPLOYMENT_END_TIME - DEPLOYMENT_START_TIME))

echo "Total Creation Time(SMM params, CloudFormation, MC): $DEPLOYMENT_DURATION seconds"
echo "Total Creation Time(SMM params, CloudFormation, MC): $DEPLOYMENT_DURATION seconds" >> nightly_output.txt

# Cloud formation smoke_test
echo "Running Smoke Test"
# python3 smoke_test.py >>  nightly_output.txt 2>&1

# Save the exit status of the Python script
SMOKE_TEST_STATUS=0

if [ $SMOKE_TEST_STATUS -eq 0 ]; then
    echo "Smoke test was successful. Continuing with bootstrap and tests."
    echo "Smoke test was successful. Continuing with bootstrap and tests." >> nightly_output.txt
    
    if [[ "$RUN_TESTS" == "true" ]]; then
      # Place the rest of your script here that should only run if smoke_test.py succeeds
      echo "Running Selenium tests..."
      pytest test_selenium_mc.py -v --tb=short >> testing_nightly_output.txt 2>&1
      
      # Concatenate makereport_output.txt to nightly_output.txt
      cat makereport_output.txt >> nightly_output.txt
      
      # Cleanup and log management
      echo "Stopping Selenium docker container..."
      sudo docker stop $CONTAINER_ID
    else
      echo "Not running Selenium tests. (--run-tests false)"
    fi
else
    echo "Smoke test failed or could not be verified. Skipping tests."
    echo "Smoke test failed or could not be verified. Skipping tests." >> nightly_output.txt
fi

if [[ "$RUN_BDD_TESTS" == "true" ]]; then
    echo "Running BDD tests..."

    # Install behave if not installed
    pip3 list | grep "behave " > out.txt
    if ! grep -q "behave " out.txt; then
      echo "Installing behave..."
      pip3 install behave
    fi

    # Install behave-testrail-reporter if needed and not installed
    if [[ "$USE_TESTRAIL" == "true" ]]; then
      pip3 list | grep "behave-testrail-reporter" > out.txt
      if ! grep -q "behave-testrail-reporter" out.txt; then
        echo "Installing behave-testrail-reporter..."
        pip3 install behave-testrail-reporter
      fi
    fi

    # set up gherkin/behave environment
    source ./set_test_params.sh

    # run gherkin/behave tests
    source ${BASE_TEST_DIR}/regression_test.sh &> behave_nightly_output.txt

    echo -e "\n\nBDD Summary: " >> nightly_output.txt
    tail -4 behave_nightly_output.txt | grep "passed, " >> nightly_output.txt
    tail -4 behave_nightly_output.txt | grep "Took " >> nightly_output.txt
    echo -e "\n\n"
else
    echo "Not running BDD tests. (--run-bdd-tests false)"
    echo "Not running BDD tests. (--run-bdd-tests false)" >> nightly_output.txt
fi

#
# Parse and print out CloudFormation events
#
cat cloudformation_events.txt |sed 's/\s*},*//g' |sed 's/\s*{//g' |sed 's/\s*\]//' |sed 's/\\"//g' |sed 's/"//g' |sed 's/\\n//g' |sed 's/\\/-/g' |sed 's./.-.g' |sed 's.\\.-.g' |sed 's/\[//g' |sed 's/\]//g' |sed 's/  */ /g' |sed 's/%//g' |grep -v StackName |grep -v StackId |grep -v PhysicalResourceId > CF_EVENTS.txt
EVENTS=$(cat CF_EVENTS.txt |grep -v ResourceProperties)
echo "$EVENTS" > CF_EVENTS.txt
cat CF_EVENTS.txt
CF_EVENTS=$(cat CF_EVENTS.txt)

# The rest of your script, including posting to Slack, can go here
# Ensure to only post to Slack if tests were run 
if [[ "$RUN_TESTS" == "true" || "$RUN_BDD_TESTS" == "true" ]]; then

  cp testing_nightly_output.txt "nightly_output_$TODAYS_DATE.txt"
  mv nightly_output_$TODAYS_DATE.txt ${LOG_DIR}
  mv selenium_unity_images/* ${LOG_DIR}

  OUTPUT=$(cat nightly_output.txt)

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

  # Post results to Slack
  curl_output=$(curl -X POST -H 'Content-type: application/json' \
    --data \
      '{
         "cloudformation_summary": "'"${OUTPUT}"'",
         "cloudformation_events": "'"${CF_EVENTS}"'",
         "bdd_output" : "'"${BDD_OUTPUT}"'",
         "logs_url": "'"${LOG_S3_PATH}/${LOG_DIR}"'",
         "bdd_output_url" : "'"${LOG_S3_PATH}/${LOG_DIR}/behave_nightly_output.txt"'"
       }' \
    ${SLACK_URL_VAL})

  echo "Curl response: ${curl_output}"
  curl_result=$(echo $curl_output | python -c "import sys, json; print(json.load(sys.stdin)['ok'])")
  if [[ "$curl_result" != "True" ]]; then
    message=$(echo "Error posting nightly test results: ${curl_output}." | jq -Ra .)
    echo $message
    curl -X POST -H 'Content-type: application/json' \
    --data '{"cloudformation_summary" : '"${message}"'}' \
    ${SLACK_URL_VAL}
  fi

else
  echo "Not posting results to slack (--run-tests or --run-bdd-tests)"
fi

# Decide on resource destruction based on the smoke test result or DESTROY flag
if [[ "$DESTROY" == "true" ]] || [ $SMOKE_TEST_STATUS -ne 0 ]; then
  # This sleep appears to eliminate a timing issue w/ DynamoDB and the terraform lock file.
  echo "Waiting 15 minutes before reclaiming resources."
  sleep 15m
  echo "Destroying resources..."
  bash destroy.sh --project-name "${PROJECT_NAME}" --venue-name "${VENUE_NAME}"
else
  echo "Not destroying resources. Smoke tests were successful and no destruction requested."
fi

#
# Clean up logs and push up to S3 if configured
#
if [[ "$RUN_TESTS" == "true" || "$RUN_BDD_TESTS" == "true" ]]; then

    # Delete logs older then 2 weeks, if any
    bash delete_old_logs.sh

    if [[ -n $LOG_S3_PATH ]]; then
        # Push the output logs/screenshots to S3 for review/auditing purposesa
        echo "Pushing test results to ${LOG_S3_PATH}..."
        if aws s3 cp ${LOG_DIR} ${LOG_S3_PATH}/${LOG_DIR} --recursive; then
            echo "Test results successfully pushed to S3."
        else
            echo "Error pushing test results to S3. Log files remain locally in ${LOG_DIR}"
        fi
    else
        echo "Not pushing results to S3 because no log-s3-path was specified on the command line. Log files remian locally in ${LOG_DIR}"
    fi
fi

