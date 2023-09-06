IaC project for hosting auto-scalable multi-AZ stateless webapp

Pre-requisites:
- AWS account
- Registered domain name
- AWS hosted zone (Alternatively, you can create `aws_route53_zone` resource in TF, and then copy-paste nameservers from the created hosted zone to your domain registrar site)