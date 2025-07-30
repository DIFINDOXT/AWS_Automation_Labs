# ⚠️ Challenges Faced: EBS Snapshot Cleanup Lambda

### 1. ⏱ Lambda Timeout (Sandbox.Timedout)
- **Problem**: The function timed out after 3 seconds
- **Solution**: Increased default timeout to 10 seconds under “General configuration”

---

### 2. 🔐 IAM Policy - Missing Snapshot Delete Permission
- **Problem**: Lambda failed silently due to lack of permission to delete snapshots
- **Solution**: Added an **inline policy** to the Lambda IAM role with the necessary `ec2:DeleteSnapshot` action

---

### 3. 📊 Log Group Missing
- **Problem**: CloudWatch log group didn’t exist on first run
- **Solution**: CloudWatch auto-creates it after the **first successful execution**

---
