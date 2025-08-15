#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${CLUSTER:-my-fargate-cluster}"
REGION="${REGION:-ap-south-1}"
NAMESPACE="${NAMESPACE:-game-2048}"
PROFILE_NAME="${PROFILE_NAME:-alb-sample-app}"

echo "[+] Creating Fargate profile '$PROFILE_NAME' for namespace '$NAMESPACE'..."
eksctl create fargateprofile \
  --cluster "$CLUSTER" \
  --region "$REGION" \
  --name "$PROFILE_NAME" \
  --namespace "$NAMESPACE" || echo "Note: profile may already exist."
