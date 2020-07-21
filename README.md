README
======

## Criação do Cluster com Anthos Service Mesh Habilitado

`$ ./create-new-cluster-asm.sh project-name-1234 cluster-name southamerica-east1-c`

## Deploy da aplicação demo

`$ ./deploy-boutique.sh`

### Obtém IP Externo para acesso à aplicação
O acesso à aplicação pode ser feito pelo IP externo dado ao Service LoadBalancer frontend-external.

`$ kubectl get svc -n demo frontend-external`

## Instala Kiali

### Cria secret para acesso

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

### Instala Kiali/Prometheus + Grafana com istioctl

`$ istioctl install --set values.kiali.enabled=true --set addonComponents.grafana.enabled=true`
