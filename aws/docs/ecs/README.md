## Aqua for Amazon ECS

Check out the video to learn how to deploy Aqua Enterprise platform on an ECS cluster via the AWS marketplace.
<div align="center">
  <a target="_blank" href="https://www.youtube.com/watch?v=WtgAxMGvtIQ"><img src="https://img.youtube.com/vi/WtgAxMGvtIQ/0.jpg" alt="IMAGE ALT TEXT"></a>
</div>

>Note: For guidance on registering additional Aqua Enforcers for Amazon ECS, please refer to [this](pages/adding-more-enforcers.md)

![Aqua platform](../../images/aws-aqua-platform.png)

## Step 1: Subscribe on the AWS Marketplace
Before launching one of our products, you'll first need to subscribe to Aqua Enterprise platform on the <a target="_blank" href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8">AWS Marketplace.</a> Click the button below to get started:
<table>
	<tr>
		<td><img src="../../images/aws-ecs-payg.gif" /></td>
	</tr>
</table>
<table>
	<tr>
		<td width="40%"><a target="_blank" href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8"><img src="../../images/aws-marketplace.png" /></a></td>
		<td>
			<h3>Aqua Enterprise platform on AWS Marketplace</h3>
			<p>Subscribe now and check out our 30-day FREE TRIAL to secure the environment of your choosing TODAY!!
			</p>
			<p align="right"><a target="_blank" href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8"><img src="../../../images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr> 
</table>

## Step 2: Configure your ECS cluster
Aqua Enterprise platform can be easily launched into your existing ECS cluster or you can create a new one from the AWS console. The self-hosted Aqua platform needs:
* At least 2 ECS instances 
* An ECS agent with version 1.30.0 or above. 

For high availability, you must deploy Aqua across 2 availability zones (AZs) and leverage a managed database solution like Amazon RDS for PostgreSQL database.

## Step 3: Launch Aqua Enterprise platform using CloudFormation
<table>
	<tr>
		<td width="25%"><a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?#/stacks/create/review?templateURL=https:%2F%2Fs3.amazonaws.com%2Faqua-security-public%2Faqua-security-ecs-payg.template&stackName=AquaSecurityEcsPayg"><img src="../../../images/aqua-logo.png" width="250"/></a></td>
		<td>
			<p>Launch Aqua Enterprise platform in a new or existing ECS cluster via easy-button deployment leveraging AWS CloudFormation template and a managed Amazon RDS Database. </p>
			<p align="right"><a target="_blank" href="https://console.aws.amazon.com/cloudformation/home?#/stacks/create/review?templateURL=https:%2F%2Fs3.amazonaws.com%2Faqua-security-public%2Faqua-security-ecs-payg.template&stackName=AquaSecurityEcsPayg"><img src="../../../images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr>
</table>

### CloudFormation Stack parameters
<table>
	<tr>
		<td><p align="center" ><img src="../../images/rds-cft-parameters.jpg" /></p></td>
	</tr>
</table>

### CloudFormation Stack output
<table>
	<tr>
		<td><img src="../../images/rds-cft-output.jpg" /></td>
	</tr>
</table>

## Step 4: Launch Aqua console
Please note the Aqua console URL from the CloudFormation Stack output above and navigate to the Aqua console in your favorite browser.
<table>
	<tr>
		<td><img src="../../images/aqua-console-aws-payg.gif" /></td>
	</tr>
</table>

If you already have one, input the Aqua license or obtain the license by filling out the form linked on the Aqua Console startup portal. You can simply reach out to us at [cloudsales@aquasec.com](mailto:cloudsales@aquasec.com) and we’ll create one for you.<br /><br />

## Step 5: Scaling out Enforcers

### Within the cluster
Aqua Enforcers are deployed as a Daemon type of ECS Service on the ECS cluster. When you scale out your cluster, the Enforcers will automatically scale out with it and get registered with the Aqua console.

### Registering new ECS clusters
For guidance on registering additional Aqua Enforcers for new Amazon ECS clusters, please refer to [this](pages/adding-more-enforcers.md)


---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.