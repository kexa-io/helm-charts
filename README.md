# helm-charts
Helm charts to install &amp; run Kexa with postgres/mariaDB and Grafana

If you do not want to use the cronjob, and just need a one time run:
    - Replace kexa-chart/templates/kexa-store.yaml with kexa-chart/store/kexa-store.yaml

### Create your secrets

Most of addon's credentials are passed in .env file, only Kubernetes addon require
a specific credential type, described below.

Refer to the official Kexa documentation to learn more about addons authentication.

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


### Install the chart

```bash
helm install kexa-helm .\kexa-chart\
```

### Read the instructions in your console !