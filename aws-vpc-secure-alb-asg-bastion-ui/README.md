# 🏗️ Secure AWS VPC Deployment with ALB, ASG & Bastion Host

This project demonstrates a **production-grade AWS architecture** for securely hosting applications inside a **VPC** with:
- Public & Private Subnets across 2 AZs
- Application Load Balancer (ALB) in Public Subnets
- Auto Scaling Group (ASG) managing EC2s in Private Subnets
- Bastion Host for secure SSH access
- NAT Gateway for secure outbound internet from private subnets
- End-to-End security with Security Groups & Health Checks

---

## 📌 Project Highlights

- ✅ Secure design (private workloads, public access only via ALB & Bastion)
- ✅ High availability (multi-AZ + ASG scaling)
- ✅ Resilient internet access (via NAT, not direct public IPs)
- ✅ Step-by-step manual implementation (Terraform automation planned later)

📖 See [PROJECT_OVERVIEW.md](./docs/PROJECT_OVERVIEW.md) for detailed concepts. 
📖 See [IMPLEMENTATION.md](./docs/IMPLEMENTATION.md) for step-by-step guide. 
📖 See [CHALLENGES.md](./docs/CHALLENGES.md) for issues & fixes. 
📸 All setup screenshots in [/screenshots](./screenshots). 

---

## Project Structure
.
├── README.md
├── app
│   ├── index-app.html
│   └── index-db.html
├── diagrams
│   ├── architecture.png
│   └── mindmap.png
├── docs
│   ├── CHALLENGES_FACED.md
│   ├── IMPLEMENTATION.md
│   ├── PROJECT_OVERVIEW.md
│   └── SSH_METHODS.md
└── screenshots

---

## Architecture

![Architecture](./diagrams/architecture.png)

---

## 🙏 Credits

- **Abhishek Veeramalla** – Idea & reference from his YouTube tutorials & GitHub repo: 
  - [YouTube Channel](https://www.youtube.com/@AbhishekVeeramalla) 
  - [GitHub Repo](https://github.com/iam-veeramalla/aws-devops-zero-to-hero)
- AWS Official Documentation
- Docker / Linux Basics
