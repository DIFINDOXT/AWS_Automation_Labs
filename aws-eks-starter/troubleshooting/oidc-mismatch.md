
## **`troubleshooting/oidc-mismatch.md`**

# Issue: OIDC Provider ID Mismatch

## Symptoms
- AccessDenied errors for `sts:AssumeRoleWithWebIdentity`
- AWS Load Balancer Controller pods fail with credential errors

## Root Cause
- OIDC provider ID in IAM trust policy does not match cluster's actual OIDC ID
- Example mismatch:
	Old OIDC: C88487EE8B7A99SBSP1D0FC0055207F4
	New OIDC: DB9FB72398C9B59BF09BA56260222BPD

## Solution
1. Get correct OIDC ID:
```
aws eks describe-cluster --name my-fargate-cluster \
  --query "cluster.identity.oidc.issuer" --output text | awk -F'/' '{print $NF}'
```

2. Update IAM trust policy:
```
aws iam update-assume-role-policy \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --policy-document file://trust.json
```

3. Restart pods:
```
kubectl -n kube-system rollout restart deploy/aws-load-balancer-controller
```

