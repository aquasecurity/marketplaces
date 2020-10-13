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

helm(){
    echo "Deploying Helm chart for Aqua Platform"
    CLUSTER_NAME="${args[0]:-aqua-cluster}"
    AWS_PROFILE="${args[1]:-default}"
    AWS_REGION="${args[2]:-us-east-1}"
    AQUA_PASSWORD="${args[3]:-Password1}"
    DB_PASSWORD="${args[4]}"

    echo "Cloning the Git repo for Aqua helm charts..."
    git clone https://github.com/aquasecurity/aws-marketplace-eks-byol.git

    echo "Install Aqua Platform using Helm..."
    helm install --namespace aqua csp ./aqua \
			 --set global.awsRegion=$AWS_REGION \
			 --set global.dbPassword=$DB_PASSWORD \
			 --set global.aquaPassword=$AQUA_PASSWORD
}

init
