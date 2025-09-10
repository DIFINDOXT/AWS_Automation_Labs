# 🔐 SSH Methods: Bastion vs ProxyJump

In this project, two SSH approaches were considered:

---

## 1) Trainer’s Method (PEM copied to Bastion)

This was the method demonstrated in the course and followed during the project.

### Steps
**From your laptop → Bastion:**
```bash
# copy PEM file into Bastion
scp -i ~/.ssh/aws-login.pem ~/.ssh/aws-login.pem ubuntu@<BASTION_PUBLIC_IP>:/home/ubuntu/

# login to Bastion
ssh -i ~/.ssh/aws-login.pem ubuntu@<BASTION_PUBLIC_IP>

# fix permissions inside Bastion
chmod 600 ~/aws-login.pem
```

# 🔐 SSH Methods: Bastion vs ProxyJump
- In this project, two SSH approaches were considered:


# From Bastion → Private EC2:
```
ssh -i ~/aws-login.pem ubuntu@<PRIVATE_IP>
```

# 📌 Pros:
- Matches trainer instructions.
- Easy for beginners to visualize.

# ⚠️ Cons:
- Less secure (private keys should not ideally be copied into remote servers).
- Extra step to manage key distribution.

---

## 2) Alternative Method (ProxyJump / No Key Copy)

- A more secure industry-standard method: keep the PEM key local and configure SSH to “jump” through the Bastion host.
- Config (on your laptop in ~/.ssh/config)

# Host bastion
    HostName <BASTION_PUBLIC_IP>
    User ubuntu
    IdentityFile ~/.ssh/aws-login.pem

Host private-ec2-a
    HostName <PRIVATE_IP_A>
    User ubuntu
    ProxyJump bastion

Host private-ec2-b
    HostName <PRIVATE_IP_B>
    User ubuntu
    ProxyJump bastion

# Usage
ssh bastion          # login directly to bastion
ssh private-ec2-a    # automatically hops via bastion
ssh private-ec2-b    # same for second instance


# 📌 Pros:
- Keys never leave your laptop.
- Scales better when multiple private EC2s exist.
- Cleaner SSH commands once config is set.

# ⚠️ Cons:
- Slightly more advanced for beginners.
- Not exactly the flow shown in trainer’s video.

---

✅ Our Choice

- For this project, we followed the trainer’s method (copy key → bastion → private EC2).
- The ProxyJump method is documented here as a secure alternative for future/production use.
