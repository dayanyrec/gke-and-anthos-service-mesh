GKE + Anthos Service Mesh
=========================

## Antes de tudo

### Instalar Cloud SDK no Mac

`$ brew install google-cloud-sdk`

### Iniciar Cloud SDK

`$ gcloud init`

### Instalar Anthos CLI

`$ ./install-anthos-cli.sh`

### Links

https://cloud.google.com/sdk/docs/quickstart-macos

https://cloud.google.com/service-mesh/docs/environment-setup#option_b_use_command-line_tools_locally

https://cloud.google.com/service-mesh/docs/install-anthos-cli

## Criar cluster GKE com Anthos Service Mesh Habilitado

`$ ./create-new-cluster-asm.sh project-name-1234 cluster-name southamerica-east1-c`

### Link

https://cloud.google.com/service-mesh/docs/gke-anthos-cli-new-cluster

## Deploy da aplicação demo

`$ ./deploy-boutique.sh`

### Obter IP Externo para acesso à aplicação

O acesso à aplicação pode ser feito pelo IP externo dado ao Service LoadBalancer frontend-external.

`$ kubectl get svc -n demo frontend-external`

### Link

https://cloud.google.com/service-mesh/docs/onlineboutique-install-kpt

## Instalar Kiali

### Criar secret para acesso

`$ KIALI_USERNAME=$(read -p 'Kiali Username: ' uval && echo -n $uval | base64)`  

`$ KIALI_PASSPHRASE=$(read -sp 'Kiali Passphrase: ' pval && echo -n $pval | base64)`  

```
$ cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: $NAMESPACE
  labels:
    app: kiali
type: Opaque
data:
  username: $KIALI_USERNAME
  passphrase: $KIALI_PASSPHRASE
EOF
```

### Instalar Kiali/Prometheus + Grafana com istioctl

`$ istioctl install --set values.kiali.enabled=true --set addonComponents.grafana.enabled=true`

### Acessar ferramentas

Kiali: `istioctl dashboard kiali`  
Prometheus: `istioctl dashboard prometheus`  
Grafana: `istioctl dashboard grafana`  

### Links

https://istio.io/latest/docs/tasks/observability/kiali/

https://istio.io/latest/docs/setup/install/istioctl/#install-istio-using-the-default-profile

https://istio.io/latest/docs/tasks/observability/metrics/querying-metrics/
