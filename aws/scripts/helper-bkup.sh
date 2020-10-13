#!/bin/bash
args=("$@")

#Config
export KUBECONFIG="eksconfig"

#GET VALUES FROM CLOUDFORMATION OUTPUT OF EKS STACK
export EKSClusterName=""
export SysOpsAdminRoleArn=""

#AWS
export REGION="us-east-1"
export USER_ARN=""
export KEY="server.pem"
export BASTION="1.1.1.1"
#aws configure --profile profile1
export AWS_PROFILE="profile1"

#Solodev
export RELEASE="solodev-dcx-aws"
export NAMESPACE="solodev-dcx"
export SECRET="BigSecret123"
export PASSWORD="password"
export DBPASSWORD="password"

#ADMIN
info(){
    kubectl --kubeconfig=$KUBECONFIG get pods -n kube-system
}

proxy(){
    token
    kubectl --kubeconfig=$KUBECONFIG port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8080:80
}

token(){
    kubectl --kubeconfig=$KUBECONFIG -n kube-system describe secret $(kubectl --kubeconfig=$KUBECONFIG -n kube-system get secret | grep eks-admin | awk '{print $1}')
}

ls(){
    kubectl --kubeconfig=$KUBECONFIG get pods --all-namespaces   
}

install(){
    NAME="${args[1]}"
    helm --kubeconfig $KUBECONFIG install --namespace ${NAMESPACE} --name ${NAME} charts/${RELEASE} --set solodev.settings.appSecret=${SECRET} --set solodev.settings.appPassword=${PASSWORD} --set solodev.settings.dbPassword=${DBPASSWORD}
}

delete(){
    NAME="${args[1]}"
    helm --kubeconfig $KUBECONFIG del --purge ${NAME}
    kubectl --kubeconfig $KUBECONFIG delete --namespace ${NAME} --all pvc
}

#UTILS
update(){
    helm --kubeconfig $KUBECONFIG repo add charts 'https://raw.githubusercontent.com/techcto/charts/master/'
    helm --kubeconfig $KUBECONFIG repo update
    helm --kubeconfig $KUBECONFIG repo list
}

clean(){
    NAME="${args[1]}"
    kubectl --kubeconfig $KUBECONFIG delete --all daemonsets,replicasets,statefulsets,services,ingress,deployments,pods,rc,configmap --namespace=${NAME} --grace-period=0 --force
    kubectl --kubeconfig $KUBECONFIG delete --namespace ${NAME} --all pvc,pv
}

#INIT
init(){
    initConfig
    helm --kubeconfig $KUBECONFIG init
    helm --kubeconfig $KUBECONFIG repo add charts 'https://raw.githubusercontent.com/techcto/charts/master/'
}

initConfig(){
    addTrustPolicy
    echo "Sleep for 30 seconds"
    sleep 30
    echo "aws eks --region $REGION update-kubeconfig --name $EKSClusterName --role-arn $SysOpsAdminRoleArn --kubeconfig $KUBECONFIG"
    aws eks --region $REGION update-kubeconfig --name $EKSClusterName --role-arn $SysOpsAdminRoleArn --kubeconfig $KUBECONFIG
}

addTrustPolicy(){
    if [ "$USER_ARN" != "" ]; then
        ROLE_NAME=$(echo $SysOpsAdminRoleArn | awk -F/ '{print $NF}')
        aws iam get-role --role-name ${ROLE_NAME} --profile ${AWS_PROFILE} > role-trust-policy.json
        POLICY='{
        "Effect": "Allow",
        "Principal": {
            "AWS": "'${USER_ARN}'"
        },
        "Action": "sts:AssumeRole"
        }'
        jq --argjson obj "${POLICY}" '.Role.AssumeRolePolicyDocument.Statement += [$obj] | .Role.AssumeRolePolicyDocument' role-trust-policy.json > output-policy.json
        aws iam update-assume-role-policy --role-name ${ROLE_NAME} --policy-document file://output-policy.json --profile ${AWS_PROFILE}
    fi
}

ssh(){
    HOST="${args[1]}"
    echo "ssh -i $KEY  ec2-user@$HOST -o \"proxycommand ssh -W %h:%p -i ${KEY} ec2-user@${BASTION}\""
}
