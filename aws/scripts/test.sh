#!/bin/bash
args=("$@")

#INIT
init(){
    echo "Inside Init function"
    CLUSTER_NAME="${args[0]:-aqua-cluster}"
    AWS_PROFILE="${args[1]:-default}"
    echo "CLUSTER NAME: ${CLUSTER_NAME}"
    echo "AWS PROFILE: ${AWS_PROFILE}"
    eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve --profile $AWS_PROFILE
    eksctl create iamserviceaccount --name aqua-sa --namespace aqua --cluster $CLUSTER_NAME --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --profile $AWS_PROFILE
}

init
