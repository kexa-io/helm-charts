# helm-charts
Helm charts to install &amp; run Kexa with postgres/mariaDB and Grafana

If you do not want to use the cronjob, and just need a one time run:
    - Replace kexa-chart/templates/kexa-store.yaml with kexa-chart/store/kexa-store.yaml


## Create your secrets

Kexa need configuration file (that define which rule to use and which addon to use) to run,
as well as the credentials for the addons you will use.

Most of addon's credentials are passed in .env file, only Kubernetes addon require
a specific credential type, described below.

Refer to the official Kexa documentation to learn more about addons authentication
and Kexa configuration.


*Upload your Kexa configuration (default.json)*
```bash
kubectl create secret generic kexa-configuration-secret --from-file=default.json=default.json
```

*Upload your environment file (for most addons credentials)*
```bash
kubectl create secret generic kexa-environment-secret --from-file=.env=.env
```

*For Kubernetes credentials*
```bash
kubectl create secret generic kubeconfig-secret --from-file=kubeconfig.yaml=kubeconfig.yaml
```

*For multiple Kubernetes credentials*
```bash
kubectl create secret generic kubeconfig-secret --from-file=kubeconfig.yaml=kubeconfig.yaml --from-file=secondkubeconfig.yaml=secondkubeconfig.yaml
```

## Using Custom rules

To use custom rules, you have two option :
  - Remote rules repository
  - Mounting your rules folder

#### With remote repository

To use a custom remote rules folder, please inform those fields in your environment file
before adding it as a secret.

```bash
  RULESDIRECTORY="https://api.github.com/repos/kexa-io/public-rules/zipball/main" # example with kexa-io/public-rules (same as default rules available in Helm chart)
  RULESAUTHORIZATION="Bearer github_pat_XXXXXXXXXXXXXXXXXXXXXXXX" # if repo is private
```

#### With folder mount

To mount a rule folder, create a folder named "tmpconfig".
Inside this folder, put the entire "rules" folder you want to use.
So you'll get a path like "tmpconfig/rules"

You'll need to input those information into your values.yaml when installing the chart :

```yaml
hostConfigPath: /mnt/host/c/your/path/to/tmpconfig
hostConfigFolder: tmpconfig
```


## Install the chart

*Adding the Kexa repository*
```bash
helm repo add YOUR_REPOSITORY_NAME https://kexa-io.github.io/helm-charts/
```

*Installing Kexa chart*
```bash
helm install YOUR_RELEASE_NAME YOUR_REPOSITORY_NAME/kexa
```
 
 
## Using Grafana

Once the chart is installed, follow the instructions displayed for Grafana.

## Using the scheduler

Once the chart is installed, wait for the pod to be ready and forward the Cronicle service with:
```
kubectl port-forward svc/kexa-helm-cronicle-svc 3012:80
```

Once on the page, create a new job to schedule, with the plugin "Shell script"
Simply copy paste the content of  "helm-charts/cronicle/jobCronicleScriptDocker.sh" into the script area.

Save & try to run it in the "schedule" section.

Now you can schedule Kexa as you wish through Cronicle


*Read the instructions in your console !*
