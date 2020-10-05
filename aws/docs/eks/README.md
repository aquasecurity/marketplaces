<a href="#"><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/aqua-header.png"/></a>

# Aqua enterprise platform for EKS
Launch Aqua enterprise platform in a new cluster or an existing cluster to secure your cloud-native workloads at any scale. Equipped with the most powerful vulnerability scanner in the market, we provide cloud native life-cycle security across the technology stack. Secure your builds, infrastructure and workloads rapidly and across AWS Regions and Availability Zones, providing a single pane of glass experience across multiple environments, with broad support for VMs, containers and serverless workloads of both Linux and Windows flavors.

## Overview
Aqua enterprise platform can be deployed on an existing EKS cluster or you can use eksctl to create a new one following the instructions. The Aqua deployment is facilitated via Helm charts for a quick and easy push-button deployment.

![Aqua platform](https://github.com/aquasecurity/marketplaces/blob/master/images/aqua-platform.png)

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
			<p align="right"><a href="https://aws.amazon.com/marketplace/pp/B07KJKMNR8"><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/subscribe-logo.png" width="200" /></a></p>
		</td>
	</tr> 
</table>

## Step 2: Pre-requisites
<table>
	<tr>
		<td width="25%"><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/aws-amazon-eks.svg" /></a></td>
		<td>
			<h3>Script to install pre-requisites</h3>
			<p>Launch the script as a sanity check for pre-requisites. This is a list of tools to make your life easy while working with Amazon EKS and deploying the Aqua platform with an easy push-button experience. These include kubectl, awscli, eksctl and helm.
			</p>
			<p align="right"><a href="https://github.com/aquasecurity/marketplaces/blob/master/aws/scripts/install_prereq.sh"><img src="https://github.com/aquasecurity/marketplaces/blob/master/images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr>
</table>

## Step 3: Launch Aqua enterprise platform for EKS via Helm
Architected as a microservices application for self-hosting, the Aqua platform is outputted as containers in the form of Kubernetes-native deployments, tailored using Helm charts. 

Before you begin, pick a deployment scenario below that best suits your needs.
<table>
	<tr>
		<td width="25%"><a href="https://github.com/aquasecurity/marketplaces/blob/master/aws/docs/eks/pages/aqua-in-a-box.md"><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/aqua-eks-dev.png" /></a></td>
		<td>
			<h3>Aqua in a box</h3>
			<p>Launch Aqua platform in a new or existing EKS cluster and secure your artifacts, hosts and workloads with Aqua. Well-suited for non-production deployments, it allows you to hit the ground running while providing a sneak peak int Aqua's full-blown cloud-native security capabilities. </p>
			<p align="right"><a href="https://github.com/aquasecurity/marketplaces/blob/master/aws/docs/eks/pages/aqua-in-a-box.md"><img src="https://github.com/aquasecurity/marketplaces/blob/master/images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr>
	<tr>
		<td width="25%"><a href="https://github.com/aquasecurity/marketplaces/blob/master/aws/docs/eks/pages/aqua-for-production.md"><img src="https://github.com/aquasecurity/marketplaces/blob/master/aws/images/aqua-eks-prod.png" /></a></td>
		<td>
			<h3>Aqua platform for production-grade deployments</h3>
			<p>Launch Aqua platform in a new or existing EKS cluster with a enterprise-grade managed PostgreSQL RDS Database. Simplified deployment leveraging CloudFormation template and Helm Charts for a better customer experience. </p>
			<p align="right"><a href="https://github.com/aquasecurity/marketplaces/blob/master/aws/docs/eks/pages/aqua-for-production.md"><img src="https://github.com/aquasecurity/marketplaces/blob/master/images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr>
</table>


## Support
If you encounter any problems, or would like to give us feedback, please contact cloud support at [Cloud Sales](mailto:cloudsupport@aquasec.com). We also encourage you to raise issues here on GitHub. Please contact us at https://github.com/aquasecurity.

---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.