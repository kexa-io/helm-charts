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

*For most addons credentials*
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


## Install the chart

*Adding the Kexa repository*
```bash
helm repo add YOUR_REPOSITORY_NAME https://kexa-io.github.io/helm-charts/
```

*Installing Kexa chart*
```bash
helm install YOUR_RELEASE_NAME YOUR_REPOSITORY_NAME/kexa
```

## Read the instructions in your console !