# Issue: ALB Not Created After Deploying Ingress

## Symptoms
- `kubectl get ingress` shows no ADDRESS assigned
- ALB not visible in AWS console
- Ingress events show:


### Error resolving ingress: no matches for ingress class "alb"

## Root Cause
- AWS Load Balancer Controller not installed or misconfigured
- Service account not annotated with correct IAM role
- Missing OIDC provider for the EKS cluster

## Solution
1. Verify AWS Load Balancer Controller is running:
```bash
kubectl get pods -n kube-system | grep aws-load-balancer-controller
```
2. Check IAM role trust policy matches OIDC provider:
```
aws iam get-role --role-name AmazonEKSLoadBalancerControllerRole
```
3. Restart controller after fixing IAM:
```
kubectl -n kube-system rollout restart deploy/aws-load-balancer-controller
```
4. Confirm Ingress:
```
kubectl describe ingress ingress-2048 -n game-2048
```

