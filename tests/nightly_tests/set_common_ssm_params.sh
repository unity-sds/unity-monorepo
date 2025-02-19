#!/bin/bash

echo "set_common_ssm_params.sh ..."

source ./define_ssm_functions.sh

#
# SSM:  /unity/cs/account/management-console/instancetype
#
MC_INSTANCETYPE_SSM="/unity/cs/account/management-console/instancetype"
MC_INSTANCETYPE_VAL="c6i.xlarge"
refresh_ssm_param "${MC_INSTANCETYPE_SSM}" "${MC_INSTANCETYPE_VAL}" \
    "management" "todo" "console" \
    "unity-all-cs-managementConsole-instanceTypeSsm"

#
# SSM:  /unity/cs/account/privilegedpolicyname
#
CS_PRIVILEGED_POLICY_NAME_SSM="/unity/cs/account/privilegedpolicyname"
CS_PRIVILEGED_POLICY_NAME_VAL="mcp-tenantOperator-AMI-APIG"
refresh_ssm_param "${CS_PRIVILEGED_POLICY_NAME_SSM}" "${CS_PRIVILEGED_POLICY_NAME_VAL}" \
    "management" "todo" "console" \
    "unity-all-cs-privilegedpolicynameSsm"

#
# SSM:  /unity/cs/github/username
#
GITHUB_USERNAME_SSM="/unity/cs/github/username"
populate_if_not_exists_ssm_param "${GITHUB_USERNAME_SSM}" \
    "management" "todo" "console" \
    "unity-all-cs-githubUsernameSsm" \
    "[please consult with team for value]"
GITHUB_USERNAME_VAL=$(get_ssm_val "$GITHUB_USERNAME_SSM")

#
# SSM:  /unity/cs/github/useremail
#
GITHUB_USEREMAIL_SSM="/unity/cs/github/useremail"
populate_if_not_exists_ssm_param "${GITHUB_USEREMAIL_SSM}" \
    "management" "todo" "console" \
    "unity-all-cs-githubUseremailSsm" \
    "[please consult with team for value]"
GITHUB_USEREMAIL_VAL=$(get_ssm_val "$GITHUB_USEREMAIL_SSM")

#
# SSM:  /unity/cs/githubtoken
#
GITHUB_TOKEN_SSM="/unity/cs/githubtoken"
populate_if_not_exists_ssm_param "${GITHUB_TOKEN_SSM}" \
    "management" "todo" "console" \
    "unity-all-cs-githubtokenSsm" \
    "[please consult with team for value]"
GITHUB_TOKEN_VAL=$(get_ssm_val "$GITHUB_TOKEN_SSM")

#
# SSM:  /unity/ci/slack-web-hook-url
#
SLACK_WEB_HOOK_URL_SSM="/unity/ci/slack-web-hook-url"
populate_if_not_exists_ssm_param "${SLACK_WEB_HOOK_URL_SSM}" \
    "management" "todo" "console" \
    "unity-all-cs-slackWebHookUrlSsm" \
    "[please consult with team for value]"
SLACK_URL_VAL=$(get_ssm_val "$SLACK_WEB_HOOK_URL_SSM")

#
# SSM:  /unity/account/network/vpc_id
#
VPC_ID_SSM="/unity/account/network/vpc_id"
VPC_ID_VAL=$(aws ec2 describe-vpcs |jq -r '.Vpcs[].VpcId')
refresh_ssm_param "${VPC_ID_SSM}" "${VPC_ID_VAL}" "networking" "na" "vpc" "unity-all-cs-networking-vpcIdSsm"

#
# SSM:  /unity/account/network/subnet_list
#
SUBNET_LIST_SSM="/unity/account/network/subnet_list"
SUBNET_LIST_VAL=$(./get_subnet_list_json.sh)
delete_ssm_param "${SUBNET_LIST_SSM}"
create_ssm_param "${SUBNET_LIST_SSM}" "${SUBNET_LIST_VAL}" "networking" "na" "vpc" "unity-all-cs-networking-subnetListSsm"

#
# SSM:  /unity/account/network/publicsubnet1
#
PUB_SUBNET_1_SSM="/unity/account/network/publicsubnet1"
PUB_SUBNET_1_VAL=$(echo "${SUBNET_LIST_VAL}" | jq -r '.public[0]')
refresh_ssm_param "${PUB_SUBNET_1_SSM}" "${PUB_SUBNET_1_VAL}" "networking" "na" "vpc" "unity-all-cs-networking-publicSubnet1Ssm"

#
# SSM:  /unity/account/network/publicsubnet2
#
PUB_SUBNET_2_SSM="/unity/account/network/publicsubnet2"
PUB_SUBNET_2_VAL=$(echo "${SUBNET_LIST_VAL}" | jq -r '.public[1]')
refresh_ssm_param "${PUB_SUBNET_2_SSM}" "${PUB_SUBNET_2_VAL}" "networking" "na" "vpc" "unity-all-cs-networking-publicSubnet2Ssm"

#
# SSM:  /unity/account/network/privatesubnet1
#
PRIV_SUBNET_1_SSM="/unity/account/network/privatesubnet1"
PRIV_SUBNET_1_VAL=$(echo "${SUBNET_LIST_VAL}" | jq -r '.private[0]')
refresh_ssm_param "${PRIV_SUBNET_1_SSM}" "${PRIV_SUBNET_1_VAL}" "networking" "na" "vpc" "unity-all-cs-networking-privateSubnet1Ssm"

#
# SSM:  /unity/account/network/privatesubnet2
#
PRIV_SUBNET_2_SSM="/unity/account/network/privatesubnet2"
PRIV_SUBNET_2_VAL=$(echo "${SUBNET_LIST_VAL}" | jq -r '.private[1]')
refresh_ssm_param "${PRIV_SUBNET_2_SSM}" "${PRIV_SUBNET_2_VAL}" "networking" "na" "vpc" "unity-all-cs-networking-privateSubnet2Ssm"

#
# SSM: /unity/account/network/certificate-arn
#
CERTIFICATE_ARN_SSM="/unity/account/network/certificate-arn"
populate_if_not_exists_ssm_param "${CERTIFICATE_ARN_SSM}" \
    "network" "todo" "certificate" \
    "unity-all-cs-certificateArnSsm" \
    "[enter the certificate ARN.  Example:  "
CERTIFICATE_ARN_VAL=$(get_ssm_val "${CERTIFICATE_ARN_SSM}")

#
# SSM:  /unity/account/eks/amis/aml2-eks-1-29
#
EKS_AMI_29_SSM="/unity/account/eks/amis/aml2-eks-1-29"
EKS_AMI_29_VAL=$(get_ssm_val "/mcp/amis/aml2-eks-1-29")
refresh_ssm_param "${EKS_AMI_29_SSM}" "${EKS_AMI_29_VAL}" "processing" "na" "vpc" "unity-all-cs-processing-aml2Eks129Ssm"

#
# SSM:  /unity/account/eks/amis/aml2-eks-1-30
#
EKS_AMI_30_SSM="/unity/account/eks/amis/aml2-eks-1-30"
EKS_AMI_30_VAL=$(get_ssm_val "/mcp/amis/aml2-eks-1-30")
refresh_ssm_param "${EKS_AMI_30_SSM}" "${EKS_AMI_30_VAL}" "processing" "na" "vpc" "unity-all-cs-processing-aml2Eks130Ssm"

#
# SSM:  /unity/shared-services/account
#
SHARED_SERVICES_AWS_ACCOUNT_SSM="/unity/shared-services/aws/account"
populate_if_not_exists_ssm_param "${SHARED_SERVICES_AWS_ACCOUNT_SSM}" \
    "account" "todo" "aws" \
    "unity-all-cs-sharedServicesAwsAccountSsm" \
    "[enter the AWS account ID of the shared services account]"
SHARED_SERVICES_AWS_ACCOUNT_VAL=$(get_ssm_val "$SHARED_SERVICES_AWS_ACCOUNT_SSM")

#
# SSM:  /unity/cs/routing/venue-api-gateway/cs-lambda-authorizer-cognito-client-id-list
#
CS_LAMBD_CLIENT_ID_LIST_SSM="/unity/cs/routing/venue-api-gateway/cs-lambda-authorizer-cognito-client-id-list"
CS_LAMBD_CLIENT_ID_LIST_VAL="na"
refresh_ssm_param "${CS_LAMBD_CLIENT_ID_LIST_SSM}" "${CS_LAMBD_CLIENT_ID_LIST_VAL}" "account" "na" "aws" "unity-all-cs-processing-lambdaAuthCognitoClientId"

#
# SSM:  /unity/shared-services/aws/account/region
# 
ACCOUNT_REGION_SSM="/unity/shared-services/aws/account/region"
ACCOUNT_REGION_VAL=$(aws ec2 describe-availability-zones --query "AvailabilityZones[0].RegionName" --output text)
refresh_ssm_param "${ACCOUNT_REGION_SSM}" "${ACCOUNT_REGION_VAL}" "account" "na" "aws" "unity-all-cs-processing-sharedServicesAwsAccountRegion"
