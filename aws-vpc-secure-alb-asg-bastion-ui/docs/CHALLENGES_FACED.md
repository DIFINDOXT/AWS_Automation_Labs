# 🐛 Challenges Faced & Fixes

This document lists the issues encountered during the project setup and how we resolved them. 
It serves both as a troubleshooting reference and as proof of real-world problem solving.

---

## 1) SSH Key Permission Errors

**Symptom:** 
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WARNING: UNPROTECTED PRIVATE KEY FILE! @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


**Cause:**
Key was copied from Windows path (`/mnt/c/...`) where it shows up as `0777` (too open).

**Fix:**
- Move PEM to `~/.ssh/` in WSL or Bastion
- Restrict permissions:
  ```
  chmod 600 ~/.ssh/aws-login.pem
```

---

## 2) SCP vs ProxyJump Confusion

#Trainer’s method: copy .pem to Bastion → use it to SSH private EC2s
```
scp -i ~/.ssh/aws-login.pem ~/.ssh/aws-login.pem ubuntu@<BASTION_PUBLIC_IP>:/home/ubuntu/
chmod 600 ~/aws-login.pem
ssh -i ~/aws-login.pem ubuntu@<PRIVATE_IP>
```

#Alternative (secure) method: keep PEM local, use ProxyJump:

Host bastion
    HostName <BASTION_PUBLIC_IP>
    User ubuntu
    IdentityFile ~/.ssh/aws-login.pem

Host private-ec2
    HostName <PRIVATE_IP>
    User ubuntu
    ProxyJump bastion


Resolution: For this project we followed the trainer’s method (copy key).
ProxyJump is documented in SSH_METHODS.md
 for future use.

---

## 3) Port 8000 Already in Use

**Symptom:**
- OSError: [Errno 98] Address already in use


**Cause:**
- A leftover python3 -m http.server 8000 process was still running.

**Fix:**
```
lsof -i:8000
kill -9 <PID>
```

- Then restart the server.

---

## 4) Target Group Shows “Unhealthy”

**Causes:**
- Health check path left as / while app only served /index.html
- Private SG did not allow port 8000 from ALB SG
- Server not running on 0.0.0.0:8000

**Fixes:**
- Set health check path to /index.html
- Correct SG rules (8000 from SG-alb)

**Verify app is serving:**
```
curl http://localhost:8000/index.html
```

---

## 5) Instances Keep Re-Creating After Termination

**Cause:**
- Auto Scaling Group (ASG) kept launching new instances to maintain desired capacity.

**Fix:**
- Set Desired/Min/Max = 0 in ASG
- Delete ASG
- Then terminate EC2s manually

---

## 6) Cleanup Dependency Errors

**Problems:**
- Couldn’t delete IGW, EIPs, NACLs in wrong order
- AWS error: “resource in use”

**Fix (deletion order):**
- ALB → 2. Target Groups → 3. EC2 Instances →
- NAT Gateways → 5. Elastic IPs → 6. Internet Gateway →
- Route Tables → 8. NACLs → 9. Subnets → 10. VPC
- See CLEANUP_CHECKLIST.md

---

## 7) Mixed Healthy/Unhealthy Nodes

**Scenario:**
- Initially only one private EC2 was running the app → LB marked the other unhealthy.
- Trainer assigned us to deploy app on both → then ALB alternated content.

**Fix:**
- Deploy app (index.html + http.server 8000) on both instances.
- Result: refresh alternates responses ✅

✅ Key Learnings
- Security group chaining (ALB SG → Private SG) is critical
- Health check path must align with app route
- ASG will override manual terminations
- Proper deletion order avoids resource lock errors

---

