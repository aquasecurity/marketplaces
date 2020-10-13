#!/bin/bash
args=("$@")

export CLUSTER_NAME='aqua-cluster'
export AWS_PROFILE='default'
export AWS_REGION='us-east-1'
export AQUA_PASSWORD=''

# These parameters need to be populated when using Amazon RDS Database for the Aqua platform deployment
export RDS_ENDPOINT=''
export RDS_PASSWORD=''

# This parameter has to be populated for containerized PostGres DB Deployment
export DB_PASSWORD=''



#INIT
init(){
    echo "Inside Init function"
    echo "CLUSTER NAME: ${CLUSTER_NAME}"
    echo "AWS PROFILE: ${AWS_PROFILE}"
    eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve --profile $AWS_PROFILE
    eksctl create iamserviceaccount --name aqua-sa --namespace aqua --cluster $CLUSTER_NAME --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve --profile $AWS_PROFILE
}

helm(){
    echo "Deploying Helm chart for Aqua Enterprise Platform"

    echo $AWS_REGION
    echo $AQUA_PASSWORD
    echo $RDS_ENDPOINT
    echo $RDS_PASSWORD
    echo $DB_PASSWORD

    echo "Cloning the Git repo for Aqua helm charts..."
#    git clone https://github.com/aquasecurity/aws-marketplace-eks-byol.git
    wget https://aqua-security-public.s3.amazonaws.com/aqua.tar
    tar -xvf aqua.tar

    echo "Install Aqua Platform using Helm..."
    if [ $RDS_ENDPOINT ];
    then
    helm install --namespace aqua csp ./aqua \
			 --set global.awsRegion=$AWS_REGION \
            --set global.dbExternalServiceHost=$RDS_ENDPOINT \
			 --set global.dbExternalPassword=$RDS_PASSWORD \
			 --set global.aquaPassword=$AQUA_PASSWORD
    else
    helm install --namespace aqua csp ./aqua \
			 --set global.awsRegion=$AWS_REGION \
			 --set global.dbPassword=$DB_PASSWORD \
			 --set global.aquaPassword=$AQUA_PASSWORD
    fi
}

$*
