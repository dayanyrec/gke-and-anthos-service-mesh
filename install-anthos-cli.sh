#! /bin/bash

echo ">> Install Kpt"
gcloud components install kpt

echo ">> Install Anthos CLI"
gcloud components install anthoscli beta

echo ">> Update gcloud components"
gcloud components update

echo "!! Next steps: "
echo "!! Run the following command to install kustomize:"
echo "!! \$ curl -s \"https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh\"  | bash"
echo "!! Add the directory where you installed kustomize to your PATH:"
echo "!! \$ export PATH=\$PWD:\$PATH"
