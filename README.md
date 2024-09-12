# helm-charts
Helm charts to install &amp; run Kexa with postgres/mariaDB and Grafana


### Create your secrets

*For most addons credentials*
```bash
kubectl create secret generic kexa-environment-secret --from-file=.env=.env
```

*For Kubernetes credentials*
```bash
kubectl create secret generic kubeconfig-secret --from-file=kubeconfig.yaml=kubeconfig.yaml
```

*For Google Workspace credentials*
```bash
kubectl create secret generic workspace-secret --from-file=workspace_credentials.json=/path/to/your/credentials.json
```

### Install the chart

```bash
helm install kexa-helm .\kexa-chart\
```

### Read the instructions in your console !