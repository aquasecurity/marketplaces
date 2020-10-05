## Adding more Enforcers to Aqua platform for GKE
This guide only deals with registering additional <b>GKE clusters</b> with your already deployed Aqua platform. 

>NOTE: We currently support Aqua versions 4.6 and above only

## Step 1: Subscribe on the GCP Marketplace
Before launching one of our products, you'll first need to subscribe to Aqua enterprise platform on the <a href="https://console.cloud.google.com/marketplace/details/aquasecurity-public/aqua-security-payg?q=aqua&project=lexical-ellipse-195321">GCP Marketplace.</a> Click the button below to get started:

<table>
	<tr>
		<td width="40%"><a href="https://console.cloud.google.com/marketplace/details/aquasecurity-public/aqua-security-payg?q=aqua&project=lexical-ellipse-195321"><img src="https://github.com/aquasecurity/marketplaces/blob/master/gcp/images/gcp-marketplace.jpg" /></a></td>
		<td>
			<h3>Aqua platform on GCP Marketplace</h3>
			<p>As a Google Cloud technology partner, Aqua platform provides the most complete security solutions to protect workloads running on GKE clusters. We provide wide support across various deployment environments like GKE on-prem as well as hybrids like Google Anthos.
			</p>
			<p align="right"><a href="https://console.cloud.google.com/marketplace/details/aquasecurity-public/aqua-security-payg?q=aqua&project=lexical-ellipse-195321"><img src="https://github.com/aquasecurity/marketplaces/blob/master/images/launch-logo.png" width="200" /></a></p>
		</td>
	</tr> 
</table>

For the installation instructions check [this](https://github.com/aquasecurity/marketplaces/blob/master/gcp).

## Step 2: Gather the required information
Since you already have Aqua installed in your GKE environment, you can easily register additional GKE environments with the same environment, by leveraging Aqua Enforcers. 

### Obtain the Aqua Gateway address from Aqua Platform
You can retrieve the Aqua Gateway URL by using kubectl tools to query your GKE cluster, where Aqua is deployed. Please note that your Gateway service has to be exposed as a ServiceType LoadBalancer for registering additional Enforcers. If that is not the case in your Aqua Platform deployment, then use kubectl commands to expose it as LoadBalancer first, as follows:
```shell
$ kubectl get svc -n aqua-container-security-1
NAME                                     TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                        AGE
aqua-container-security-1-database-svc   ClusterIP      10.48.1.123   <none>          5432/TCP                       37m
aqua-container-security-1-gateway-svc    ClusterIP      10.48.6.41    <none>          3622/TCP                       37m
aqua-container-security-1-server-svc     LoadBalancer   10.48.0.97    35.239.131.96   443:30297/TCP,8080:32227/TCP   37m

$ kubectl edit svc aqua-container-security-1-gateway-svc -n aqua-container-security-1
# Edit the spec section
spec:
  clusterIP: 10.48.6.41
  ports:
  - port: 3622
    protocol: TCP
    targetPort: 3622
  selector:
    app: aqua-container-security-1-gateway
  sessionAffinity: None
  type: ClusterIP                               # -> Change this to "LoadBalancer"

# New spec should look like this:
spec:
  clusterIP: 10.48.6.41
  ports:
  - port: 3622
    protocol: TCP
    targetPort: 3622
  selector:
    app: aqua-container-security-1-gateway
  sessionAffinity: None
  type: LoadBalancer

$ kubectl edit svc aqua-container-security-1-gateway-svc -n aqua-container-security-1
service/aqua-container-security-1-gateway-svc edited

# Now you can see that GKE is spinning up a brand new LoadBalancer for the Aqua Gateway service
$ kubectl get svc -n aqua-container-security-1
NAME                                     TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                        AGE
aqua-container-security-1-database-svc   ClusterIP      10.48.1.123   <none>          5432/TCP                       42m
aqua-container-security-1-gateway-svc    LoadBalancer   10.48.6.41    <pending>       3622:31752/TCP                 42m
aqua-container-security-1-server-svc     LoadBalancer   10.48.0.97    35.239.131.96   443:30297/TCP,8080:32227/TCP   42m

# After a couple of minutes you should be able to retrieve the External IP
$ kubectl get svc -n aqua-container-security-1
NAME                                     TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                        AGE
aqua-container-security-1-database-svc   ClusterIP      10.48.1.123   <none>          5432/TCP                       44m
aqua-container-security-1-gateway-svc    LoadBalancer   10.48.6.41    34.68.42.171    3622:31752/TCP                 44m
aqua-container-security-1-server-svc     LoadBalancer   10.48.0.97    35.239.131.96   443:30297/TCP,8080:32227/TCP   44m

Aqua-GW URL: 34.68.42.171:3622

```

## Step 3: Get the aquactl tool and license

### Aquactl
Aquactl is a command-line tool that provides a wide variety of functionality related to Aqua CSP deployment and operation. You can get the latest aquactl binary and make it executable.
>Linux: https://get.aquasec.com/aquactl/stable/aquactl
>Mac: https://get.aquasec.com/aquactl/mac/stable/aquactl

```shell
wget https://get.aquasec.com/aquactl/stable/aquactl
chmod +x aquactl
```
### Aqua License
If you already have one, input the Aqua license or obtain the license by filling out the form linked on the Aqua Console startup portal. You can simply reach out to us at [cloudsales@aquasec.com](mailto:cloudsales@aquasec.com) and we’ll create one for you.<br /><br />
You will need the credentials to pull the Aqua enforcer image from our registry.

## Step 4: Registering more Enforcers
Make sure you switch the context to the new GKE cluster you want to register. Use the aquactl tool deploy the enforcers.

```shell
# Switch context to the new GKE cluster
gcloud container clusters get-credentials cluster-1 --zone us-east1-c --project lexical-ellipse-195321

# Deploy enforcers using aquactl
aquactl deploy enforcer --version <aqua_version> --gateway <gateway_url>

```

Here's a screenshot of the installation
![GCP enforcer](https://github.com/aquasecurity/marketplaces/blob/master/gcp/images/gke-enforcer.png)

## Step 5: Verify in the Aqua Console
Please navigate to the Aqua console in your favorite browser and follow the steps:

### Create an Enforcer Group
In the console, go to the <b>Enforcers</b> tab and click on ```Add Enforcer Group```. 
![Enforcer group](https://github.com/aquasecurity/marketplaces/blob/master/aws/images/enforcer-group.png)

Add in the relevant details and make sure to <b>check all the security settings</b> before clicking on ```Create Group```
![Enforcer group creation](https://github.com/aquasecurity/marketplaces/blob/master/gcp/images/create-group.png)

### Approve the Enforcers
Navigate back to the Enforcers tab, and you will see that Aqua has discovered the new Enforcers running in the new GKE Cluster. Select all and click on Approve.

---
Visit [aquasec.com](https://www.aquasec.com/) to learn more.