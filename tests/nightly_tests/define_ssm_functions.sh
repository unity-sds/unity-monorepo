#!/bin/bash

#
# Sub-routine to check, and populate if missing
#
populate_if_not_exists_ssm_param() {
    local key=$1
    local capability=$2
    local capVersion=$3
    local component=$4
    local name=$5
    local suggestedDefault=$6
    echo "populate_if_not_exists_ssm_param: ${key} ..."
    aws ssm get-parameter --name "$key" > /dev/null 2>ssm_lookup.txt
    if [[ `grep "ParameterNotFound" ssm_lookup.txt | wc -l` == "1" ]]; then
        echo "SSM param ${key} not found."
        echo "Suggested value to use here: ${suggestedDefault}"
        echo "ENTER VALUE to set for ${key}: "
        read user_input
        create_ssm_param "${key}" "${user_input}" "${capability}" "${capVersion}" "${component}" "${name}"
    else
        echo "SSM param ${key} exists. Continuing..."
    fi
    rm ssm_lookup.txt
}

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
# Sub-routine to create a SSM parameter,
# and tag it (ensuring mandatory AWS resource tags are applied)
#
create_ssm_param() {
    local key=$1
    local value=$2
    local capability=$3
    local capVersion=$4
    local component=$5
    local name=$6
echo "Creating SSM parameter : ${key}"
    aws ssm put-parameter --name "${key}" --value "${value}" --type String \
    --tags \
    "Key=Venue,Value=${VENUE_NAME}" \
    "Key=ServiceArea,Value=cs" \
    "Key=Capability,Value=${capability}" \
    "Key=CapVersion,Value=${capVersion}" \
    "Key=Component,Value=${component}" \
    "Key=Name,Value=${name}" \
    "Key=Proj,Value=${PROJECT_NAME}" \
    "Key=CreatedBy,Value=cs" \
    "Key=Env,Value=${VENUE_NAME}" \
    "Key=Stack,Value=${component}" &>/dev/null
    # TODO: Is there a SSM Description field (to add above)?
    if [ $? -ne 0 ]; then
        echo "ERROR: SSM create failed for $key"
    fi
}

#
#
#
refresh_ssm_param() {
    local key=$1
    local value=$2
    local capability=$3
    local capVersion=$4
    local component=$5
    local name=$6
    delete_ssm_param "${key}" &> /dev/null
    create_ssm_param "${key}" "${value}" "${capability}" "${capVersion}" "${component}" "${name}" &> /dev/null
}

get_ssm_val() {
    local key=$1
    aws ssm get-parameter --name ${key} --with-decryption --query 'Parameter.Value' --output text
}
