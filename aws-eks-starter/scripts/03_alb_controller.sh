#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${CLUSTER:-my-fargate-cluster}"
REGION="${REGION:-ap-south-1}"

echo "[+] Install/upgrade AWS Load Balancer Controller (Helm)..."
helm repo add eks https://aws.github.io/eks-charts >/dev/null 2>&1 || true
helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$CLUSTER" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region="$REGION"

echo "[+] Wait for controller to be ready..."
kubectl -n kube-system rollout status deploy/aws-load-balancer-controller
echo "[✓] Controller ready."
