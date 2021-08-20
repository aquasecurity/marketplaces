# Launch Aqua in a box for EKS

## Overview
This deployment scenario provides a <b><i>starter environment</b></i> that includes a <b>database container for Postgres</b>, leveraging a persistent volume to store data. This architecture is not scalable or resilient enough for production workloads, but extremely useful for evaluation.

Just follow these <b>4 SIMPLE STEPS</b> to get up and running.

![Deployment Scenario 1](../../../images/Deployment_Scenario1.png)


## Step 1: Configure Your EKS cluster
Aqua can easily be launched into an existing EKS environment or you can [spin up a new one](#create-a-new-EKS-cluster). using [https://eksctl.io/]. 
<br>

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

## Step 2: Create a Service account with EKS IAM permissions
This command helps you set up the required <b>IAM permissions</b> required by Aqua Platform to run smoothly on Amazon EKS. 
```shell
eksctl utils associate-iam-oidc-provider --cluster=<cluster_name> --approve [--profile=<profile>]
eksctl create iamserviceaccount --name aqua-sa --namespace aqua --cluster <cluster_name> --attach-policy-arn arn:aws:iam::aws:policy/AWSMarketplaceMeteringRegisterUsage --approve [--profile <profile>]
```

## Step 3: Deploy the Aqua Enterprise platform

You can retrieve the Helm chart from the ECR repository.
```shell
export HELM_EXPERIMENTAL_OCI=1

aws ecr get-login-password \
	--region us-east-1 | helm registry login \
	--username AWS \
	--password-stdin 709825985650.dkr.ecr.us-east-1.amazonaws.com

helm chart pull 709825985650.dkr.ecr.us-east-1.amazonaws.com/aqua-security-software/aqua-helm:5.3.0

helm chart export 709825985650.dkr.ecr.us-east-1.amazonaws.com/aqua-security-software/aqua-helm:5.3.0 --destination ./charts
```

Install the Aqua Helm chart:
```shell
helm install csp --namespace aqua ./charts/aqua \
			--set global.imageTag="6.0.21083" \
			--set global.awsRegion=<aws_region_for_eks> \
			--set global.dbPassword=<db_password> \
			--set global.aquaPassword=<admin_password>
```

## Step 4: Launch Aqua console
Obtain the Aqua console URL by running the following command
```shell
AQUA_CONSOLE=$(kubectl get svc csp-console-svc --namespace aqua -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
  
ECHO "http://$AQUA_CONSOLE:8080"
```

Please note the Aqua console URL above and navigate to the Aqua console in your favorite browser.
<table>
	<tr>
		<td><img src="../../../images/aqua-console-aws-payg.gif" /></td>
	</tr>
</table>

If you already have one, input the Aqua license or obtain the license by filling out the form linked on the Aqua Console startup portal. You can simply reach out to us at [cloudsales@aquasec.com](mailto:cloudsales@aquasec.com) and we’ll create one for you.<br /><br />

## Appendix
### Create a new EKS cluster
Creation of an EKS cluster can be simplified using eksctl commands: [https://eksctl.io/].
<br>If you choose to use a separate EKS environment solely to host the Aqua Enterprise platform, then it is recommended that you create a <i><b>private nodegroup</b></i> in your EKS cluster and use a <b>NAT gateway</b> for communication.
>Please note that you will have to create an EC2 Keypair if SSH access is desired for the nodes.
```shell
eksctl create cluster --name aqua-cluster --region us-east-1 --zones us-east-1a,us-east-1b --nodegroup-name private-ng1 --nodes 2 --ssh-public-key <EC2_keypair> --node-private-networking --vpc-nat-mode HighlyAvailable
```
---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.
