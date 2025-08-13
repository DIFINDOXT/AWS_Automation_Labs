#!/usr/bin/env bash
set -e
CLUSTER=${1:-my-fargate-cluster}
REGION=${2:-ap-south-1}
eksctl create fargateprofile --cluster "$CLUSTER" --region "$REGION" \
  --name game-2048-profile --namespace game-2048
