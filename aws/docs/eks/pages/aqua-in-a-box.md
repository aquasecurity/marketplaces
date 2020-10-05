# Launch Aqua in a box for EKS

## Overview
Please note that this deployment scenario provides a starter environment that includes a database container for Postgres, leveraging a persistent volume to store data. This architecture is not scalable or resilient enough for production workloads, but extremely useful for evaluation.
![Deployment Scenario 1](https://github.com/aquasecurity/marketplaces/blob/master/aws/images/Deployment_Scenario1.png)

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

## Step 2: Create a Service account with EKS IAM permissions
Download and configure the [helper_script](https://github.com/aquasecurity/marketplaces/blob/master/aws/scripts/helper_script.sh). 
<br>This script supports the following parameters:

<table>
	<tr>
		<th width="33%"><strong>Parameter</strong></th>
		<th width="600px"><strong>Description</strong></th>
	</tr>
	<tr>
		<td>ClusterName</td>
		<td>The name of your EKS Cluster (set to "aqua-cluster" by default). Please note, the name must be all lowercase.</td>
	</tr>
	<tr>
		<td>AWSRegion</td>
		<td>The AWS Region of your EKS Cluster (set to "us-east-1" by default). Please note, the name must be all lowercase.</td>
	</tr>
	<tr>
		<td>ProfileName</td>
		<td>The name of your AWS profile set in the local $HOME/.aws/config file used by AWS CLI (set to "default" by default). Please note, the name must be all lowercase.</td>
	</tr>
	<tr>
		<td>ClusterName</td>
		<td>The name of your stack (set to "solodev-cms" by default). Please note, the name must be all lowercase.</td>
	</tr>
</table>


## Step 3: Deploy Aqua platform using Helm
The Aqua Helm chart exposes certain configuration values for tweaking the deployment to your needs. 
```shell
git clone https://github.com/aquasecurity/aws-marketplace-eks-byol.git

helm install --namespace aqua csp ./aqua \
			 --set global.awsRegion=<aws_region_for_eks> \
			 --set global.dbPassword=<db_password> \
			 --set global.aquaPassword=<aqua_password>
```
## Step 4: Launch Aqua console
Obtain the Aqua console URL by running the following command
```shell
AQUA_CONSOLE=$(kubectl get svc csp-aqua-console --namespace aqua -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
  
ECHO "http://$AQUA_CONSOLE:8080"
```

Please note the Aqua console URL above and navigate to the Aqua console in your favorite browser.
<table>
	<tr>
		<td><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/aqua-console-aws-payg.gif" /></td>
	</tr>
</table>

If you already have one, input the Aqua license or obtain the license by filling out the form linked on the Aqua Console startup portal. You can simply reach out to us at [cloudsales@aquasec.com](mailto:cloudsales@aquasec.com) and we’ll create one for you.<br /><br />

## Appendix
### Create a new EKS cluster
Creation of an EKS cluster can be simplified using eksctl commands: [https://eksctl.io/].
<br>If you choose to use a separate EKS environment solely to host the Aqua CSP platform, then it is recommended that you create a private nodegroup in your EKS cluster and use a NAT gateway for communication.
<br>
>Please note that you will have to create an EC2 Keypair if SSH access is desired for the nodes.
```shell
eksctl create cluster --name aqua-cluster --region us-east-1 --zones us-east-1a,us-east-1b --nodegroup-name private-ng1 --nodes 2 --ssh-public-key <EC2_keypair> --node-private-networking --vpc-nat-mode HighlyAvailable
```
---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.