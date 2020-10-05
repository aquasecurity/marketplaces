## Aqua for Amazon ECS

![Aqua platform](https://github.com/aquasecurity/marketplaces/blob/master/images/aqua-platform.png)

>Note: For guidance on registering additional Aqua Enforcers for Amazon ECS, please refer to [this](https://github.com/aquasecurity/marketplaces/blob/master/aws/docs/ecs/pages/adding-more-enforcers.md)

## Step 1: Subscribe on the AWS Marketplace
Before launching one of our products, you'll first need to subscribe to Aqua enterprise platform on the <a href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8">AWS Marketplace.</a> Click the button below to get started:
<table>
	<tr>
		<td><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/ecs-payg-2.gif" /></td>
	</tr>
</table>
<table>
	<tr>
		<td width="40%"><a href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8"><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/aws-marketplace.png" /></a></td>
		<td>
			<h3>Aqua platform on AWS Marketplace</h3>
			<p>As an Advanced APN member and Container Competency technology partner, Aqua platform provides the most complete security solutions to protect workloads running on Amazon ECS, EKS, AWS Fargate and AWS Lambda. Subscribe now to secure the environment of your choosing.
			</p>
			<p align="right"><a href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8"><img src="https://github.com/aquasecurity/marketplaces/blob/master/images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr> 
</table>

## Step 2: Configure your ECS cluster
Aqua platform can be easily launched into your existing ECS cluster or you can create a new one from the AWS console. The self-hosted Aqua platform needs at least 2 ECS instances and an ECS agent with version 1.30.0 or above. For high availability, you must deploy Aqua across 2 availability zones (AZs) and leverage a managed database solution like Amazon RDS for PostgreSQL database.

## Step 3: Launch Aqua enterprise platform using CloudFormation
<table>
	<tr>
		<td width="25%"><a href="https://console.aws.amazon.com/cloudformation/home?#/stacks/create/review?templateURL=https:%2F%2Fs3.amazonaws.com%2Faqua-security-public%2Faqua-security-ecs-payg.template&stackName=AquaSecurityEcsPayg"><img src="https://github.com/aquasecurity/marketplaces/blob/master/images/aqua-logo.png" width="250"/></a></td>
		<td>
			<h3>Aqua in a box</h3>
			<p>Launch Aqua platform in a new or existing EKS cluster and run your artifacts, hosts and workloads securely with Aqua. Well-suited for non-production deployments, it allows you to hit the ground running while providing a sneak peak int Aqua's full-blown cloud-native security capabilities. Architected as a microservices application, the Aqua platform is outputted as containers in the form of Kubernetes-native deployments, launched within a namespace. </p>
			<p align="right"><a href="https://console.aws.amazon.com/cloudformation/home?#/stacks/create/review?templateURL=https:%2F%2Fs3.amazonaws.com%2Faqua-security-public%2Faqua-security-ecs-payg.template&stackName=AquaSecurityEcsPayg"><img src="https://github.com/aquasecurity/marketplaces/blob/master/images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr>
</table>

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

## Step 4: Launch Aqua console
Please note the Aqua console URL from the CloudFormation Stack output above and navigate to the Aqua console in your favorite browser.
<table>
	<tr>
		<td><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/aqua-console-aws-payg.gif" /></td>
	</tr>
</table>

If you already have one, input the Aqua license or obtain the license by filling out the form linked on the Aqua Console startup portal. You can simply reach out to us at [cloudsales@aquasec.com](mailto:cloudsales@aquasec.com) and we’ll create one for you.<br /><br />

---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.