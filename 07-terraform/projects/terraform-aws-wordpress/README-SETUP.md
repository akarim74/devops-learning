# WordPress on AWS using Terraform

This project provisions a public EC2 instance running WordPress with Apache, PHP and MariaDB, inside a custom VPC with a public subnet, internet gateway, route table and HTTP security group.

## Before switching from the previous configuration

If the old Terraform deployment still exists, run `terraform destroy` from the **original** project directory before replacing or renaming its resources. Do not copy an existing Terraform state file into this new directory or apply both configurations against the same live resources.

## Deploy

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and adjust the values if desired. Defaults are already provided in `variables.tf`, so this file is optional.
2. Ensure AWS credentials are configured for Terraform.
3. Run `terraform init`, `terraform fmt`, `terraform validate`, `terraform plan`, and `terraform apply`.
4. Retrieve the URL with `terraform output wordpress_url`. Allow time for EC2 user data to complete.
5. Complete the WordPress setup wizard using **temporary credentials only**: this lab uses HTTP, not HTTPS.
6. Run `terraform destroy` when finished to avoid charges.

The AMI is resolved dynamically from AWS Systems Manager's public Amazon Linux 2023 parameter, unless `ami_id` is supplied. The AZ defaults to the first available AZ in the selected region. This is a single-instance learning lab, not a production-hardened or highly available WordPress deployment. Public IPv4 addresses can incur AWS charges.

`http_port` is configurable for the security group, but the included Apache setup serves on port 80. Keep it at 80 unless you also update the server configuration.
