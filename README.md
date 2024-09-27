# helm-charts
Helm charts to install &amp; run Kexa with postgres/mariaDB and Grafana

If you do not want to use the cronjob, and just need a one time run:
    - Replace kexa-chart/templates/kexa-store.yaml with kexa-chart/store/kexa-store.yaml

First, create the namspace.
```bash
kubectl create namespace kexa
```

## Create your secrets

Kexa need configuration file (that define which rule to use and which addon to use) to run,
as well as the credentials for the addons you will use.

Most of addon's credentials are passed in .env file, only Kubernetes addon require
a specific credential type, described below.

Refer to the official Kexa documentation to learn more about addons authentication
and Kexa configuration.

To automatically be connected to the Postgres database deployed with Helm chart, you'll need
the following save addon in your "_default.json_":
```json
    "save": [
        {
            "type": "postgres",
            "name": "Postgres local cluster",
            "urlName": "POSTGRES_STRING",
            "description": "Database to save the data (local cluster)"
        }
    ]
```

*Upload your Kexa configuration (default.json)*
```bash
kubectl create secret generic kexa-configuration-secret --from-file=default.json=default.json -n kexa
```

*Upload your environment file (for most addons credentials)*
```bash
kubectl create secret generic kexa-environment-secret --from-file=.env=.env -n kexa
```

*For Kubernetes credentials*
```bash
kubectl create secret generic kubeconfig-secret --from-file=kubeconfig.yaml=kubeconfig.yaml -n kexa
```

*For multiple Kubernetes credentials*
```bash
kubectl create secret generic kubeconfig-secret --from-file=kubeconfig.yaml=kubeconfig.yaml --from-file=secondkubeconfig.yaml=secondkubeconfig.yaml -n kexa
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
uselocalRules: true
```

or when installing the chart

```yaml
 helm install kexa-helm kexa/kexa -n kexa --set hostConfigPath="/mnt/host/c/your/path/to/tmpconfig" --set uselocalRules="true"
```

## Install the chart

*Adding the Kexa repository*
```bash
helm repo add kexa https://kexa-io.github.io/helm-charts/
```

*Installing Kexa chart*
```bash
helm install YOUR_RELEASE_NAME kexa/kexa -n kexa
```

*Installing chart (using Kubernetes cronjob instead of Cronicle Scheduler)*
```bash
helm install YOUR_RELEASE_NAME kexa/kexa -n kexa --set kexaKubeCronJob="*/2 * * * *" --set kubernetesAddon.mountPath="kexakubeconfigs" # 2 minutes cronjob
```

If running with Kubernetes cronjob, you'll also need precise the Kubernetes mount path
in you're env (choose any name, but use the same for .env and values.yaml)

.env for kubernetes cronjob:
```bash
PREFIX_KUBECONFIG=kexakubeconfigs/kubeconfig.yaml
```

## Using Grafana

Once the chart is installed, follow the instructions displayed for Grafana.

## Using the scheduler

Once the chart is installed, wait for the pod to be ready and forward the Cronicle service with:
```
kubectl port-forward svc/kexa-helm-cronicle-svc 3012:80 -n kexa
```

Once on the page, create a new job to schedule, with the plugin "Shell script"
Simply copy paste the content of  "helm-charts/cronicle/jobCronicleScriptDocker.sh" into the script area.

Save & try to run it in the "schedule" section.

Now you can schedule Kexa as you wish through Cronicle


*Read the instructions in your console!*

## Custom Values

```yaml
# app name
appname: kexa-helm

namespace: kexa

# local rules folder mount
hostConfigPath: /mnt/host/c/your/path/to/tmpconfig
hostConfigFolder: tmpconfig
uselocalRules: false

# kubernetes addon
kubernetesAddon:
  enabled: true
  mountPath: kubernetesconfigurations

# kubernetes cronjob (instead of using Cronicle)
kexaKubeCronJob: "0 0 29 2 1"

# Kexa version
kexaScript:
  image: innovtech/kexa
  tag: latest

# database connection
# can only be reconfigured here
grafana.ini:
  database:
    type: "postgres"
    host: "my-postgresql.kexa.svc.cluster.local"
    name: "kexa_export_database"
    user: "kexa_postgres_user"
    password: "my_postgres_password"
    ssl_mode: "disable"


# postgres
postgresql:
  image:
    tag: "15.0.0"
  livenessProbe:
    initialDelaySeconds: 200
  readinessProbe:
    initialDelaySeconds: 200
  host: my-postgresql.kexa.svc.cluster.local
  fullnameOverride: "my-postgresql"
  connectionString: "postgresql://kexa_postgres_user:my_postgres_password@my-postgresql.kexa.svc.cluster.local:5432/kexa_export_database"
  auth:
    postgresPassword: my_postgres_password
    username: kexa_postgres_user
    password: my_postgres_password
    database: kexa_export_database
  persistence:
    enabled: true
    size: 10Gi
  primary:
    service:
      port: 5432
```