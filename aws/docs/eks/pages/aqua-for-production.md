# Launch Aqua platform for production-ready EKS environment

## Overview
A production-grade Aqua platform deployment requires a managed Postgres database installation like Amazon RDS. Click here for RDS requirements. This is a highly scalable and resilient architecture recommended for production workloads.
![Deployment Scenario 2](../../../images/Deployment_Scenario2.png)

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

## Step 2: Create Amazon RDS Postgres database
Aqua recommends implementing a dedicated managed database like Amazon RDS for an enterprise-grade experience. 
<table>
	<tr>
		<td width="35%"><p align="center"><img src="../../../images/rds-icon.png" /></a></p></td>
		<td>
			<h3>Amazon RDS for Aqua platform</h3>
			<p>Launch the CloudFormation stack to deploy an Amazon RDS database in the same VPC as your EKS cluster. 
			</p>
			<p align="right"><a href="https://console.aws.amazon.com/cloudformation/home?#/stacks/new?stackName=aqua-rds&templateURL=https://aqua-security-public.s3.amazonaws.com/AquaRDS.yaml"><img src="../../../../images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr>
</table> 

### CloudFormation Stack parameters
<table>
	<tr>
		<td><img src="../../../images/rds-cft-parameters.jpg" /></td>
	</tr>
</table>

### CloudFormation Stack output
<table>
	<tr>
		<td><img src="../../../images/rds-cft-output.jpg" /></td>
	</tr>
</table>

## Step 3: Create a Service account with EKS IAM permissions
Download and configure the [helper_script](../../../scripts/helper_script.sh). 

```shell
wget https://aqua-security-public.s3.amazonaws.com/helper_script.sh
```

Configure the script for the following parameters, by downloading and editing the file:

<table>
	<tr>
		<th width="23%"><strong>Parameter</strong></th>
        <th width="25%"><strong>Default value</strong></th>
		<th width="52%"><strong>Description</strong></th>
	</tr>
	<tr>
		<td>ClusterName</td>
        <td>aqua-cluster</td>
		<td>The name of your EKS Cluster. Please note, the name must be all lowercase.</td>
	</tr>
	<tr>
		<td>AWSRegion</td>
        <td>us-east-1</td>
		<td>The AWS Region of your EKS Cluster. Please note, the name must be all lowercase.</td>
	</tr>
	<tr>
		<td>ProfileName</td>
        <td>default</td>
		<td>The name of your AWS profile set in the local $HOME/.aws/config file used by AWS CLI. Please note, the name must be all lowercase.</td>
	</tr>
	<tr>
		<td>DBPassword</td>
        <td></td>
		<td>The password for the Aqua RDS Database for your deployment.</td>
	</tr>
	<tr>
		<td>AquaPassword</td>
        <td></td>
		<td>The administrator password for your Aqua Web Console.</td>
	</tr>
</table>

```shell
export CLUSTER_NAME='aqua-cluster'
export AWS_PROFILE='default'
export AWS_REGION='us-east-1'
export AQUA_PASSWORD=''

# These parameters need to be populated when using Amazon RDS Database for the Aqua platform deployment
export RDS_ENDPOINT=''
export RDS_PASSWORD=''


```

### Execute the script for IAM setup
This script helps you set up the required IAM permissions required by Aqua Platform to run smoothly on Amazon EKS. 
```shell
chmod +x helper_script.sh
./helper_script.sh init

```

## Step 3: Deploy the Aqua Enterprise platform

### Deploy using the helper_script
In addition, the script also helps you install the Aqua platform using Helm Charts.

```shell
./helper_script.sh install_aqua
```

### Deploy using manual Helm commands
If you would rather deploy Aqua yourself using Helm commands, use the following instructions.
The Aqua Helm chart exposes certain configuration values for tweaking the deployment to your needs. 
```shell
wget https://aqua-security-public.s3.amazonaws.com/aqua.tar
tar -xvf aqua.tar

helm install --namespace aqua csp ./aqua \
			 --set global.awsRegion=<aws_region_for_eks> \
			 --set global.ExternalDB="enabled" \
			 --set global.ExternalDBHost=<rds_endpoint> \
			 --set global.dbExternalPassword=<db_password> \
			 --set global.aquaPassword=<aqua_password>
```

## Step 4: Launch Aqua console
Obtain the Aqua console URL by running the following command
```shell
AQUA_CONSOLE=$(kubectl get svc csp-console-svc --namespace aqua -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
  
echo "http://$AQUA_CONSOLE:8080"
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
<br>If you choose to use a separate EKS environment solely to host the Aqua CSP platform, then it is recommended that you create a private nodegroup in your EKS cluster and use a NAT gateway for communication.
<br>
>Please note that you will have to create an EC2 Keypair if SSH access is desired for the nodes.
```shell
eksctl create cluster --name aqua-cluster --region us-east-1 --zones us-east-1a,us-east-1b --nodegroup-name private-ng1 --nodes 2 --ssh-public-key <EC2_keypair> --node-private-networking --vpc-nat-mode HighlyAvailable
```
---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.