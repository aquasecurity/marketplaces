## Adding more Enforcers to Aqua Enterprise Platform for Amazon ECS
This guide only deals with registering additional <b>Amazon ECS clusters</b> with your already deployed Aqua Enterprise platform. 

For installation instructions check [this](../../../README.md) out.

>NOTE: We currently support Aqua versions 4.6 and above only

## Step 1: Pre-requisites
Before the addition of more enforcers to your Aqua environment, you'll first need to install Aqua enterprise platform from the <a target="_blank" href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8">AWS Marketplace.</a> Our listing enables you to install the Aqua platform on Amazon EKS or ECS or even Fargate. Click the button below to get started:
<table>
	<tr>
		<td><img src="../../../images/ecs-payg-2.gif" /></td>
	</tr>
</table>
<table>
	<tr>
		<td width="40%"><a target="_blank" href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8"><img src="../../../images/aws-marketplace.png" /></a></td>
		<td>
			<h3>Aqua platform on AWS Marketplace</h3>
			<p>As an Advanced APN member and Container Competency technology partner, Aqua platform provides the most complete security solutions to protect workloads running on Amazon ECS, EKS, AWS Fargate and AWS Lambda. Subscribe now to secure the environment of your choosing.
			</p>
			<p align="right"><a target="_blank" href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8"><img src="../../../../images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr> 
</table>

For the installation instructions check [this](../../../README.md) for service-specific instructions.

## Step 2: Gather the required information
Since you already have Aqua installed in your AWS environment, you can easily register additional environments (Amazon EKS, ECS or AWS Fargate) with the same environment, by leveraging Aqua Enforcers. Moreover, your Aqua platform environment can exist on any AWS service and you can still register your ECS cluster with it.

### Obtain the Aqua Gateway address from Aqua Platform
**<details><summary>Aqua Platform on Amazon ECS</summary>**

  #### From CloudFormation
  If you deployed Aqua to Amazon ECS via the AWS Marketplace using CloudFormation, then retrieve the Gateway address from the CloudFormation Stack Outputs.

  ![CFT Stack output](../../../images/gw-stack-output.png)

  #### From ECS Cluster
  If you want to retrieve it from the ECS Cluster where Aqua Platform is deployed, then go to the ECS Cluster page under ```Services``` tab, and click on the ```aqua-gateway``` service. This will provide you with the LoadBalancer created for the Aqua Gateway service.
  Clicking on the link will take you to the LoadBalancer page from where you can get the DNS Name and port 3622

  ![GW LB](../../../images/gw-lb.png)

  Example: ecs-AquaGateway-1097015082.us-east-1.elb.amazonaws.com:3622

</details>

**<details><summary>Aqua Platform on Amazon EKS</summary>**

  You can retrieve the Aqua Gateway URL by using kubectl tools to query your EKS cluster. Please note that your Gateway service has to be exposed as a ServiceType LoadBalancer for registering additional Enforcers. If that is not the case in your Aqua Platform deployment, then use kubectl commands to expose it as LoadBalancer first, as follows:
  ```shell
  kubectl get svc -n aqua

  kubectl edit svc csp-gateway-svc -n aqua
  ```

</details>

## Step 3: Launch CloudFormation for additional Enforcers
<table>
	<tr>
		<td width="25%"><a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?#/stacks/create/review?templateURL=https:%2F%2Fs3.amazonaws.com%2Faqua-security-public%2Faqua-security-ecs-payg.template&stackName=AquaSecurityEcsPayg"><img src="../../../../images/aqua-logo.png" width="250"/></a></td>
		<td>
			<h3>Aqua in a box</h3>
			<p>Register new ECS clusters with Aqua Enterprise platform with just a click of a button via AWS CloudFormation. </p>
			<p align="right"><a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?#/stacks/create/review?templateURL=https:%2F%2Fs3.amazonaws.com%2Faqua-security-public%2Faqua-security-ecs-payg.template&stackName=AquaSecurityEcsPayg"><img src="../../../../images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr>
</table>

### CloudFormation Stack parameters
<table>
	<tr>
		<td><img src="../../../images/cft-add-enforcer-params.png" /></td>
	</tr>
</table>


## Step 4: Verify in the Aqua Console
Please navigate to the Aqua console in your favorite browser and follow the steps:

### Create an Enforcer Group
In the console, go to the <b>Enforcers</b> tab and click on ```Add Enforcer Group```. 
![Enforcer group](../../../images/enforcer-group.png)

Add in the relevant details and make sure to <b>check all the security settings</b> before clicking on ```Create Group```
![Enforcer group creation](../../../images/create-group.png)

### Approve the Enforcers
Navigate back to the Enforcers tab, and you will see that Aqua has discovered the new Enforcers running in the new ECS Cluster. Select all and click on Approve.

---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.