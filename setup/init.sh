#!/bin/bash
set -e -o pipefail

echo "Fetching IAM github-actions-user ARN"
userarn=$(aws iam get-user --user-name github-actions-user | jq -r .User.Arn)

# Download tool for manipulating aws-auth
echo "Downloading tool..."
curl -X GET -L https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_windows_amd64.exe -o aws-iam-authenticator.exe
chmod +x aws-iam-authenticator.exe

echo "Updating permissions"
./aws-iam-authenticator.exe add user --userarn="${userarn}" --username=github-action-role --groups=system:masters --kubeconfig="$HOME"/.kube/config --prompt=false

echo "Cleaning up"
rm aws-iam-authenticator
echo "Done!"