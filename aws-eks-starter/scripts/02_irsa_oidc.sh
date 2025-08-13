#!/usr/bin/env bash
set -e
CLUSTER=${1:-my-fargate-cluster}
eksctl utils associate-iam-oidc-provider --cluster "$CLUSTER" --approve
