#! /bin/bash

echo "Setup environment variables"
PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3

echo "Set gcloud project and region"
gcloud config set project ${PROJECT_ID}
gcloud config set compute/zone ${CLUSTER_LOCATION}

echo "Download asm resources"
kpt pkg get \
https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git/asm@release-1.6-asm .

echo "Set asm values"
kpt cfg set asm gcloud.container.cluster ${CLUSTER_NAME}
kpt cfg set asm gcloud.core.project ${PROJECT_ID}
kpt cfg set asm gcloud.compute.location ${CLUSTER_LOCATION}

echo "List asm values"
kpt cfg list-setters asm/

echo "Install Anthos Service Mesh"
gcloud beta anthos apply asm

echo "Register the cluster"
SERVICE_ACCOUNT_NAME=${CLUSTER_NAME}

gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
   --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
   --role="roles/gkehub.connect"

SERVICE_ACCOUNT_KEY_PATH=/tmp/creds/${SERVICE_ACCOUNT_NAME}-${PROJECT_ID}.json

gcloud iam service-accounts keys create ${SERVICE_ACCOUNT_KEY_PATH} \
   --iam-account=${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

gcloud container hub memberships register ${CLUSTER_NAME} \
    --gke-cluster=${CLUSTER_LOCATION}/${CLUSTER_NAME} \
    --service-account-key-file=${SERVICE_ACCOUNT_KEY_PATH}

kubectl label namespace default istio-injection=enabled --overwrite
