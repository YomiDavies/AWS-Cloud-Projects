## AWS-CLOUD-PROJECTS




### About Me

I'm Yomi, an AWS Certified Solutions Architect Associate based in Canada, transitioning into a cloud engineering role. This repository is a collection of hands-on AWS projects I've built to demonstrate real-world cloud skills across infrastructure provisioning, containerization, automation, and more.
I believe in learning by building — every project here reflects a concept I've worked through end-to-end, from design to deployment.


## Skills & Tools

| Category | Technologies |
| -------- | -------- |
| Cloud  | AWS (EC2,VPC,IAM,ALB,ASG,SSMS3, and more)  |
| Infrastrucure as Code   | Terraform  |
| Containers   | Docker, Docker Compose  |
| Scripting   | Python, Bash   |
| Version Control  | Git, GitHub |
| Operating Systems   | Linux (Amazon Linux, RHEL), macos, windows   |




## Projects

| Project  | Description| Tools    |
| -------- | --------   | -------- |
| Event-Announcement-System  | A notification platform that enables users to create events and real-time updates via email       | S3, Lambda, SNS, API Gateway, IAM roles and Policies |
| Multi-tier Web Application  with Terraform|Provisioned a production-style AWS environment with a custom VPC, public/private subnets across two AZs, NAT Gateways, an internet-facing ALB, and an Auto Scaling Group running Apache web servers — all managed with Terraform | Terraform, AWSVPC, ALB, ASG, EC2, IAM, SSM
| CI-CD  | create a CICD pipeline that takes code from a local computer and automatically deploys it on AWS cloud   | Cell 2   |
|Event Announcement System| a notification platform that enables users to create events and receive real-time updates via email  |S3,   |


I built a notification platform that enables users to create events and receive real-time updates via email. It’s a lightweight yet scalable system using AWS’s core offerings:

✅ Amazon S3 – Hosted the static website and stored event data in a JSON format.

✅ AWS SNS (Simple Notification Service) – Handled email subscriptions and notifications for new events.

✅ AWS Lambda – Powered the backend logic, including creating events and managing subscriber data.

✅ Amazon API Gateway – Provided RESTful endpoints to facilitate communication between the frontend and backend.

✅ IAM Roles & Policies – Implemented to enforce secure access control between AWS services.

💡 Key Skills Demonstrated:

Building serverless applications with AWS

API design and integration

Event-driven architecture

Secure resource management using IAM

End-to-end project deployment using only AWS services

