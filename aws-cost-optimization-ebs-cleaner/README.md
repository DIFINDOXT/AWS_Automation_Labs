# 🧹 AWS Cloud Cost Optimization: EBS Snapshot Cleaner (Lambda-based)

This project identifies **stale EBS snapshots** in your AWS account and automatically deletes them using **AWS Lambda**. It's an effective cost optimization technique for reducing unnecessary storage charges.

---

## 📌 Use Case

Over time, your team may:
- Terminate EC2 instances but leave their EBS snapshots
- Retain volume snapshots of long-gone development/test environments
- Forget to periodically audit snapshots manually

These unused EBS snapshots silently **accrue monthly charges**.

---

## 🚀 What This Project Does

✅ Lists all EBS snapshots owned by your account  
✅ Checks for attached volumes and linked EC2 instances  
✅ Deletes:
	- Snapshots not associated with any volume
	- Snapshots of volumes not attached to any **running** EC2 instance

---

## 🧠 When To Use This Project

Use this Lambda-based cleanup in the following situations:

| Scenario                                                       | Use This Project?                     |
|----------------------------------------------------------------|---------------------------------------|
| EC2 snapshots are accumulating                                 | ✅ Yes                                |
| You want automated cost cleanup                                | ✅ Yes                                |
| Looking to avoid EC2 costs (no dedicated server to run script) | ✅ Yes                                |
| Want to integrate cleanup into CloudWatch schedule             | ✅ Yes                                |
| Snapshots must be retained for compliance                      | ❌ No (add retention filters instead) |

---

## 💡 Benefits

- Saves on hidden EBS snapshot costs
- Fully serverless → no EC2 required
- One-click cleanup (trigger manually or schedule with CloudWatch)
- Easy to extend and customize

---

## 📂 Project Structure

```
aws-cost-optimization-ebs-cleaner/
├── lambda_function.py         # Main Lambda logic (boto3)
├── README.md                  # You're reading it :)
├── challenges_faced.md        # Problems faced + solutions
└-*/*/*── screenshots/               # Screenshots of IAM + Lambda setup
```

---

## 📸 Screenshots

See `/screenshots` folder for setup steps:
- IAM Role + Inline Policy
- Lambda creation
- Test event + successful deletion
- CloudWatch logs

---

## 📚 Inspired By

Project idea based on [Abhishek Veeramalla](https://github.com/iam-veeramalla/aws-devops-zero-to-hero/tree/main/day-17)'s AWS Cost Optimization series.

This version includes:
- Custom IAM inline policy
- Log monitoring with CloudWatch
- Optional CloudWatch Event Rule support

---

## 🛡️ Disclaimer

- Always **test in non-production accounts first**
- This version **deletes snapshots** if not attached to any active volume or EC2 instance
- You can modify the logic to **retain** snapshots with tags, specific volumes, or ages

---

## 🤝 Contributions

If you want to add features like:
- Cost reporting to SNS/Email
- Retention filters (30 days)
- Tag-based snapshot exclusions

...PRs welcome!

