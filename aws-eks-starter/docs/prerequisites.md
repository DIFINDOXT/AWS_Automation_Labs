# Prerequisites

This project deploys a containerized 2048 game application on AWS EKS with Fargate and an Application Load Balancer (ALB) ingress controller.

---

## AWS Requirements
- **AWS Account** with billing enabled
- **IAM User/Role** with AdministratorAccess or equivalent permissions
- **AWS CLI** configured with `aws configure`

---

## Local Environment Setup
- **Operating System**: Linux/macOS/WSL2 (Windows Subsystem for Linux)
- **AWS CLI**: v2.15+
- **kubectl**: v1.30+
- **eksctl**: v0.181+
- **Helm**: v3.14+
- **jq**: v1.7+ (for JSON parsing)

---

## Kubernetes Components
- **EKS Cluster**: `my-fargate-cluster` (ap-south-1)
- **Fargate Profile** for running application pods
- **AWS Load Balancer Controller** for ingress

---

## Application
- **Container Image**: 2048 game container (public image)
- **Namespace**: `game-2048`
- **Ingress Class**: `alb`

---

Ensure all tools are installed and verified before starting:
```bash
aws --version
kubectl version --client
eksctl version
helm version
jq --version
