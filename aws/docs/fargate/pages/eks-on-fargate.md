# Configure Aqua platform to support EKS on Fargate workloads

## Overview
If you are looking for guidance to use Aqua for securing your EKS on Fargate workloads, this is a How-To guide to achieve that. This guide utilizes a demo Gotty application workload to be run in EKS on Fargate and describes the process of securing it via Aqua for evaluation. Aqua provides you with a MicroEnforcer that can be deployed using two approaches to secure your workloads: <b>Embedded within images</b> or <b>Attached as a sidecar</b>. This guide demonstrates how both can be accomplished in EKS on Fargate, though embedded MicroEnforcers should work in any environment.

 

## Pre-requisites
This setup assumes that you already have Aqua platform deployed and running in AWS. The only pre-requisite is that the Aqua-gateway service is exposed via a Public Loadbalancer.

## Configure the environment
### Step 1: Create an EKS cluster with Fargate or use an existing on to run workloads
Create the EKS cluster with a Fargate profile
```shell
```

Configure kubectl and verify connectivity
```shell
eksctl utils write-kubeconfig --cluster aqua-eks
[ℹ]  eksctl version 0.18.0
[ℹ]  using region us-east-1
[✔]  saved kubeconfig as "/Users/foo/.kube/config"

kubectl get nodes
NAME                                      STATUS   ROLES    AGE     VERSION
ip-192-168-46-32.ec2.internal             Ready    <none>   8h      v1.15.11-eks-065dce
ip-192-168-7-143.ec2.internal             Ready    <none>   8h      v1.15.11-eks-065dce
```
Create the Fargate namespace
```shell
kubectl create ns fargate-demo
```

### Step 2: Prepare ECR repositories

### Step 3: Prepare Aqua platform

## Deploying the vulnerable workload
This section demonstrates how a vulnerable workload can be exploitable and how Aqua's MicroEnforcer secures such workload and prevents that scenario.

### Without Aqua
Let's go ahead and deploy the vulnerable Gotty application in EKS by creating a Fargate Pod:
```shell
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: sidecar
  name: sidecar-679cbf7b57-5kndk
  namespace: sidecar-demo
spec:
  # Aqua uses InitContainers to obtain the microenforcer binary from Aqua using the k8s secret created earlier for access to Aqua's private registry. Please be sure to provide the appropriate Aqua version.
  initContainers:
  - image: curlimages/curl:latest
    imagePullPolicy: Always
    name: sidecar
    env:
    # Specify the appropriate Aqua version
    - name: version
      value: 5.0
    - name: username
      valueFrom:
        secretKeyRef:
          name: aqua
          key: username
    - name: password
      valueFrom:
        secretKeyRef:
          name: aqua
          key: password
    command: ["/bin/sh", "-c" ,"curl --user $(username):$(password) https://download.aquasec.com/micro-enforcer/$(version)/microenforcer > /test/microenforcer && chmod +x /test/microenforcer" ]
    resources: {}
    volumeMounts:
    - name: sidecar
      mountPath: /test
  containers:
  - image: 779593258376.dkr.ecr.us-east-1.amazonaws.com/manasip-gotty:latest
    imagePullPolicy: Always
    name: gotty-vulnerable
    # These env vars allow the workload to communicate back to the Aqua console which is the command center for the security policies to be applied
    env:
    # AQUA_SERVER is the public address for the Aqua-gateway service
    - name: AQUA_SERVER
      value: ab00d70d3c167461c97bab4b17e8e02c-2091474829.us-east-1.elb.amazonaws.com:8443
    # AQUA_TOKEN is the token used to connect to the Enforcer Group created in Step 3
    - name: AQUA_TOKEN
      value: 0397ac4d-4a10-4af8-b3cd-43026fbf0c8c
    resources: {}
    ports:
    - name: gotty
      containerPort: 8080
    # This command makes sure that the workload is using the Aqua microenforcer as the entrypoint
    command: ["/test/microenforcer", "/usr/local/bin/gotty", "--permit-write", "--reconnect", "/bin/sh"]
    volumeMounts:
    - mountPath: /test
      name: sidecar
  restartPolicy: Never
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  # This is the shared volume between the workload container and the Aqua initContainer
  volumes:
  - name: sidecar
    emptyDir: {}
status:
```

### Approach 1: Embedded within images
### Approach 2: Attached as an Init Container
If you do not want to modify your container images and prefer to secure your workloads by running Init Containers (sidecars) during deployment, then this approach is for you.

#### 1. Create a secret for Aqua registry credentials
```shell
kubectl create secret generic aqua --from-literal="username"=<aqua_username> --from-literal="password"=<aqua_password> -n sidecar-demo
```
```shell
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: sidecar
  name: sidecar-679cbf7b57-5kndk
  namespace: sidecar-demo
spec:
  # Aqua uses InitContainers to obtain the microenforcer binary from Aqua using the k8s secret created earlier for access to Aqua's private registry. Please be sure to provide the appropriate Aqua version.
  initContainers:
  - image: curlimages/curl:latest
    imagePullPolicy: Always
    name: sidecar
    env:
    # Specify the appropriate Aqua version
    - name: version
      value: 5.0
    - name: username
      valueFrom:
        secretKeyRef:
          name: aqua
          key: username
    - name: password
      valueFrom:
        secretKeyRef:
          name: aqua
          key: password
    command: ["/bin/sh", "-c" ,"curl --user $(username):$(password) https://download.aquasec.com/micro-enforcer/$(version)/microenforcer > /test/microenforcer && chmod +x /test/microenforcer" ]
    resources: {}
    volumeMounts:
    - name: sidecar
      mountPath: /test
  containers:
  - image: 779593258376.dkr.ecr.us-east-1.amazonaws.com/manasip-gotty:latest
    imagePullPolicy: Always
    name: gotty-vulnerable
    # These env vars allow the workload to communicate back to the Aqua console which is the command center for the security policies to be applied
    env:
    # AQUA_SERVER is the public address for the Aqua-gateway service
    - name: AQUA_SERVER
      value: ab00d70d3c167461c97bab4b17e8e02c-2091474829.us-east-1.elb.amazonaws.com:8443
    # AQUA_TOKEN is the token used to connect to the Enforcer Group created in Step 3
    - name: AQUA_TOKEN
      value: 0397ac4d-4a10-4af8-b3cd-43026fbf0c8c
    resources: {}
    ports:
    - name: gotty
      containerPort: 8080
    # This command makes sure that the workload is using the Aqua microenforcer as the entrypoint
    command: ["/test/microenforcer", "/usr/local/bin/gotty", "--permit-write", "--reconnect", "/bin/sh"]
    volumeMounts:
    - mountPath: /test
      name: sidecar
  restartPolicy: Never
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  # This is the shared volume between the workload container and the Aqua initContainer
  volumes:
  - name: sidecar
    emptyDir: {}
status:
```

### CloudFormation Stack parameters
<table>
	<tr>
		<td><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/rds-cft-parameters.jpg" /></td>
	</tr>
</table>

### CloudFormation Stack output
<table>
	<tr>
		<td><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/rds-cft-output.jpg" /></td>
	</tr>
</table>

## Step 3: Create a Service account with EKS IAM permissions
Download and configure the [helper_script](https://github.com/aquasecurity/marketplaces/blob/master/aws/scripts/helper_script.sh). 
<br>This script supports the following parameters:

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
		<td>ClusterName</td>
        <td>blah</td>
		<td>The name of your stack. Please note, the name must be all lowercase.</td>
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