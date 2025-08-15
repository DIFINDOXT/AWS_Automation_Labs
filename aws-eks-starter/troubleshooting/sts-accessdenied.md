## **`troubleshooting/sts-accessdenied.md`**

# Issue: AccessDenied During AssumeRoleWithWebIdentity

## Symptoms
- ALB controller logs show:

	AccessDenied: Not authorized to perform sts:AssumeRoleWithWebIdentity



## Root Cause
- Missing `"sts:AssumeRoleWithWebIdentity"` in IAM trust policy
- Wrong namespace/service account mapping


## Solution
1. Verify service account annotation:
```
kubectl get sa aws-load-balancer-controller -n kube-system -o yaml
```
Should include:
annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::<account-id>:role/AmazonEKSLoadBalancerControllerRole

2. Update trust policy (trust.json) and apply:
```
aws iam update-assume-role-policy --role-name AmazonEKSLoadBalancerControllerRole --policy-document file://trust.json
```

3. Restart pods:
```
kubectl -n kube-system rollout restart deploy/aws-load-balancer-controller
```

