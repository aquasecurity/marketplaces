# Launch additional Enforcers to connect other EKS clusters

## Overview
This guide only deals with registering additional <b>EKS clusters</b> with your already deployed Aqua platform. 
For installation instructions check [this](../aqua-in-a-box.md) out.

## Step 1: Obtain Aqua Gateway address from your existing EKS cluster
Since you already have Aqua installed in your EKS environment, you can easily register additional EKS environments with the same environment, by leveraging Aqua Enforcers. 

### Obtain the Aqua Gateway address from Aqua Platform
You can retrieve the Aqua Gateway URL by using kubectl tools to query your EKS cluster, where Aqua is deployed. Please note that your Gateway service has to be exposed as a ServiceType LoadBalancer for registering additional Enforcers. If that is not the case in your Aqua Platform deployment, then use kubectl commands to expose it as LoadBalancer first, as follows:
```shell
$kubectl get svc -n aqua
NAME               TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)                        AGE
csp-console-svc    LoadBalancer   10.100.226.178   a1379862c1c424368b01fc1052eb7774-246959784.us-east-1.elb.amazonaws.com   8080:30821/TCP,443:31629/TCP   108m
csp-database-svc   ClusterIP      10.100.151.220   <none>                                                                   5432/TCP                       108m
csp-gateway-svc    ClusterIP      10.100.178.125   <none>                                                                   3622/TCP,8443/TCP              108m

$kubectl patch svc csp-gateway-svc -n aqua -p '{"spec": {"type": "LoadBalancer"}}'
service/csp-gateway-svc patched

$kubectl get svc -n aqua
NAME               TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)                         AGE
csp-console-svc    LoadBalancer   10.100.226.178   a1379862c1c424368b01fc1052eb7774-246959784.us-east-1.elb.amazonaws.com   8080:30821/TCP,443:31629/TCP    3h42m
csp-database-svc   ClusterIP      10.100.151.220   <none>                                                                   5432/TCP                        3h42m
csp-gateway-svc    LoadBalancer   10.100.178.125   aaac1e5b3ec1b4bb094b9806a09829c9-415394354.us-east-1.elb.amazonaws.com   3622:31455/TCP,8443:32373/TCP   3h42m

AQUA_GW=$(kubectl get svc csp-gateway-svc --namespace aqua -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
echo $AQUA_GW
```

### Create an Enforcer Group in the Aqua Console for the new EKS Cluster
Navigate to the Aqua Console and click on Administrator > Enforcers tab to add an Enforcer Group
![Enforcer group](../../aws/images/create-enforcer-group)

Add in the relevant details and make sure to take note of the Deployment Token that is added. Scroll to the bottom and click to Change the Audit Settings on this group.
![Token](../../aws/images/token)

In the Settings, set everything to Enforce and enable the Host Images and Risk Explorer
![Settings](../../aws/images/audit-settings)

## Step 2: Configure the EKS Cluster and Service account with EKS IAM permissions
Configure the kubeconfig file for your EKS cluster on your local machine.
```shell
eksctl utils write-kubeconfig --cluster=<name> [--kubeconfig=<path>][--profile=<profile>][--set-kubeconfig-context=<bool>]
```

Verify the node status
```shell
kubectl get nodes
```

Create the aqua namespace
```shell
kubectl create ns aqua
```

This command helps you set up the required <b>IAM permissions</b> required by Aqua Platform to run smoothly on Amazon EKS. 
```shell
eksctl utils associate-iam-oidc-provider --cluster=<cluster_name> --approve [--profile=<profile>]
eksctl create iamserviceaccount --name aqua-sa --namespace aqua --cluster <cluster_name> --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve [--profile <profile>]
```

## Step 3: Deploy the Aqua Enforcers

You can retrieve the Helm chart from the ECR repository.
```shell
export HELM_EXPERIMENTAL_OCI=1

aws ecr get-login-password \
	--region us-east-1 | helm registry login \
	--username AWS \
	--password-stdin 709825985650.dkr.ecr.us-east-1.amazonaws.com

helm chart pull 709825985650.dkr.ecr.us-east-1.amazonaws.com/aqua-security-software/aqua-helm:5.3.2

helm chart export 709825985650.dkr.ecr.us-east-1.amazonaws.com/aqua-security-software/aqua-helm:5.3.2 --destination ./charts
```

Extract the Enforcer subchart for install
```shell
cd charts/aqua/charts
gzip -d enforcer-5.3.tgz
tar -xvf enforcer.tar
```

Install the Aqua Helm chart:
```shell
helm install csp --namespace aqua ./charts/aqua/charts/enforcer \
    --set global.imageTag="6.2.21171" \
    --set global.awsRegion=<aws_region_for_eks> \
    --set global.externalGW=$AQUA_GW \
    --set global.enforcerToken=<token> \
    --set global.imageCredentials.registry=709825985650.dkr.ecr.us-east-1.amazonaws.com/aqua-security-software
```

## Step 4: Verify in the Aqua console
Navigate to the Aqua console and go to Administrator > Enforcers and see if the connection was successful

---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.
