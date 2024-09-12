# helm-charts
Helm charts to install &amp; run Kexa with postgres/mariaDB and Grafana


### Create your secrets

```bash
kubectl create secret generic kexa-environment-secret --from-file=.env=.env
```

### Install the chart

```bash
helm install kexa-helm .\kexa-chart\
```

### Read the instructions in your console !