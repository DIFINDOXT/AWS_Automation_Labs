#!/usr/bin/env bash
set -euo pipefail

CLUSTER="${CLUSTER:-my-fargate-cluster}"
REGION="${REGION:-ap-south-1}"
ROLE_NAME="${ROLE_NAME:-AmazonEKSLoadBalancerControllerRole}"
TRUST_FILE="${TRUST_FILE:-trust.json}"

echo "[+] Associate IAM OIDC provider (IRSA) if not present..."
eksctl utils associate-iam-oidc-provider --cluster "$CLUSTER" --region "$REGION" --approve

echo "[+] Resolve ACCOUNT_ID and OIDC_ID..."
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
OIDC_ID=$(aws eks describe-cluster --name "$CLUSTER" \
  --query "cluster.identity.oidc.issuer" --output text | awk -F'/' '{print $NF}')

echo "[+] Generate $TRUST_FILE with correct OIDC ID..."
cat > "$TRUST_FILE" <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Principal":{"Federated":"arn:aws:iam::${ACCOUNT_ID}:oidc-provider/oidc.eks.${REGION}.amazonaws.com/id/${OIDC_ID}"},
    "Action":"sts:AssumeRoleWithWebIdentity",
    "Condition":{
      "StringEquals":{
        "oidc.eks.${REGION}.amazonaws.com/id/${OIDC_ID}:aud":"sts.amazonaws.com",
        "oidc.eks.${REGION}.amazonaws.com/id/${OIDC_ID}:sub":"system:serviceaccount:kube-system:aws-load-balancer-controller"
      }
    }
  }]
}
EOF

echo "[+] Create controller IAM policy if missing..."
curl -fsSLo iam_policy.json \
  https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json >/dev/null 2>&1 || true

echo "[+] Create/Update IAM role + Kubernetes SA via eksctl..."
eksctl create iamserviceaccount \
  --cluster "$CLUSTER" \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --role-name "$ROLE_NAME" \
  --attach-policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy" \
  --approve

echo "[+] Ensure trust policy is exact (handles OIDC mismatches)..."
aws iam update-assume-role-policy --role-name "$ROLE_NAME" --policy-document file://"$TRUST_FILE"

echo "[✓] IRSA + trust policy ready."
