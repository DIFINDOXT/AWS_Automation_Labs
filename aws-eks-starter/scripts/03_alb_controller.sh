#!/usr/bin/env bash
set -e
CLUSTER=${1:-my-fargate-cluster}
REGION=${2:-ap-south-1}
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
VPC_ID=$(aws eks describe-cluster --name "$CLUSTER" --query "cluster.resourcesVpcConfig.vpcId" --output text)

# policy
curl -fsSLO https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json >/dev/null 2>&1 || true

# IRSA role for controller
eksctl create iamserviceaccount \
  --cluster="$CLUSTER" --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

# Helm install
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system --set clusterName="$CLUSTER" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region="$REGION" \
  --set vpcId="$VPC_ID"

kubectl -n kube-system rollout status deploy/aws-load-balancer-controller
