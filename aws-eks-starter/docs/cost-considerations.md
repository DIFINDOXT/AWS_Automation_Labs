# Cost Considerations

Running this EKS + Fargate + ALB stack incurs costs. Here's the breakdown and optimization steps.

---

## Services Used and Cost Factors

### 1. EKS Cluster
- Control plane: ~$0.10/hour
- Charged even if no workloads run

### 2. AWS Fargate
- Billed per vCPU/hour and GB/hour
- Example: Small workloads (0.25 vCPU, 0.5 GB RAM) for 1 hour cost a few cents

### 3. Application Load Balancer (ALB)
- Charged per hour + LCU (Load Capacity Units)
- Ingress testing may incur costs even when idle

### 4. EBS Volumes (if used)
- Orphaned volumes can incur daily charges

### 5. NAT Gateway (if mistakenly created)
- ~$32/month per gateway
- Not used in this project if correctly configured for Fargate public access

---

## Optimization Recommendations
- **Delete unused clusters** immediately after testing:
```bash
eksctl delete cluster --name my-fargate-cluster --region ap-south-1

---

## Remove unused load balancers:

aws elbv2 describe-load-balancers
aws elbv2 delete-load-balancer --load-balancer-arn <ARN>

---

## Check for orphaned EBS volumes:

aws ec2 describe-volumes --filters Name=status,Values=available
```
- Remove unused Elastic IPs and NAT Gateways.

---

## Clean-up
Follow the cleanup guide in the main README to avoid surprise bills.
