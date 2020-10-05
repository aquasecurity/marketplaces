# Configuring the Aqua operator for Red Hat OpenShift environment
Operator is the most Kubernetes-native way of managing the lifecycle of applications. They are purpose-built to run a Kubernetes application, with operational knowledge baked in, making smarter and more tailored than generic tools. Aqua operator provides a number of Custom Resources (CR) that enable you to create and configure the different Aqua application components.

## Step 1: Configure OpenShift cluster
The only pre-requisite for the deployment is having an OpenShift cluster registered with the Red Hat marketplace with an aqua project created. Use the Red Hat marketplace console to subscribe to the Aqua platform listing and install the operator in the ```aqua``` namespace.

<table>
	<tr>
		<td><img src="https://github.com/aquasecurity/marketplaces/blob/master/redhat/images/install-operator-new.gif" width="100%"/></td>
    </tr>
</table>

## Step 2: Configure Aqua operator
Once the operator is installed, leverage the ```Cluster console``` button on the Red Hat Marketplace console to navigate to the OpenShift cluster. Make sure you have selected the ```aqua``` project in the drop-down. In the ```Installed Operators``` tab, you can see that the operator has been installed successfully. 
<table>
	<tr>
		<td><img src="https://github.com/aquasecurity/marketplaces/blob/master/redhat/images/operator-install.png" /></td>
	</tr>
</table>

For ease of use, Aqua also provides an easy button deployment in the form of Aqua CSP CR. This particular CR enables you to create the complete Aqua CSP application with just one click, thus simplifying the deployment instead of dealing with the components separately. Moreover, it does not take away any configurability and allows you to tweak settings for each of the Aqua pieces such as the number of replicas, route creation, etc.
<br>

<b><u>GIF showing the operator configuration</b></u>
<table>
	<tr>
		<td><h3>GIF showing operator configuration</h3></td>
	</tr>
</table>


---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.