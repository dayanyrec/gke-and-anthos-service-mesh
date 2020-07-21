#! /bin/bash

kpt pkg get \
  https://github.com/GoogleCloudPlatform/microservices-demo.git/release \
  hipster-demo

kubectl create namespace demo

kubectl label namespace demo istio-injection=enabled

kubectl apply -n demo -f hipster-demo

kubectl get service frontend-external -n demo

