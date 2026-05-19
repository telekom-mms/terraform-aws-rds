<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![Unlicense License][license-shield]][license-url]

<br />

<!-- PROJECT LOGO -->
<div align="center">
  <a href="https://github.com/telekom-mms/terraform-aws-rds">
    <img src="logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">AWS RDS & Aurora Module</h3>

  <p align="center">
    PSA-compliant RDS and Aurora module with mandatory encryption, RDS Proxy support, and Serverless v2 integration.
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-rds"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/telekom-mms/terraform-aws-rds">View Demo</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-rds/issues/new?labels=bug&template=bug-report---.md">Report Bug</a>
    ·
    <a href="https://github.com/telekom-mms/terraform-aws-rds/issues/new?labels=enhancement&template=feature-request---.md">Request Feature</a>
  </p>
</div>

## Documentation

Full auto-generated documentation of inputs, outputs, and resources: [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md)

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#advanced-features">Advanced Features</a></li>
    <li><a href="#security-features">Security Features</a></li>
    <li><a href="#psa-compliance-features">PSA Compliance Features</a></li>
    <li><a href="#outputs">Outputs</a></li>
    <li><a href="#troubleshooting">Troubleshooting</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

This module provides a production-ready, security-first foundation for relational databases on AWS. It supports standard RDS instances, Aurora Clusters (including Serverless v2), and RDS Proxy for advanced connection management.

### Features

- **Standard RDS & Aurora**: Toggle between standalone instances and high-availability clusters.
- **Aurora Serverless v2**: Native support for autoscaling compute capacity.
- **RDS Proxy**: Integrated connection pooling and security filtering.
- **KMS Encryption**: Mandatory encryption at rest with optional CMK creation.
- **IAM Authentication**: Enabled by default for modern access control.
- **Performance Insights**: Integrated monitoring for database performance tuning.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE -->
## Usage

### Basic Usage (Standard RDS)

```hcl
module "db" {
  source = "./terraform-aws-rds"

  project_name = "myapp"
  environment  = "prod"
  
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.medium"
  
  master_password = var.db_password # Use Secrets Manager in production
  
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.database_subnets
  security_group_ids = [module.sg.db_tier_sg_id]
}
```

### Advanced Usage (Aurora Serverless v2 + Proxy)

```hcl
module "aurora" {
  source = "./terraform-aws-rds"

  create_aurora_cluster = true
  engine                = "aurora-postgresql"
  
  aurora_serverless_v2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 16
  }
  
  create_db_proxy = true
  db_proxy_auth = [
    {
      auth_scheme = "SECRETS"
      secret_arn  = aws_secretsmanager_secret.db_creds.arn
      iam_auth    = "REQUIRED"
    }
  ]
  # ... other variables
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SECURITY FEATURES -->
## Security Features

- **Encryption at Rest**: Mandatory SSE-KMS for all storage and snapshots.
- **SSL/TLS Enforcement**: Parameter groups are pre-configured to force encrypted connections (e.g., `rds.force_ssl=1`).
- **No Public Access**: `publicly_accessible` is hardcoded to `false` to prevent exposure.
- **Deletion Protection**: Enabled by default to prevent accidental data loss.
- **IAM Auth**: Enabled by default to allow token-based authentication.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- PSA COMPLIANCE FEATURES -->
## PSA Compliance Features

This module implements the following PSA compliance features (referencing `05-Strukturierte_PSA_Anforderungen_DB_Hadoop_LLM.pdf`):

### Security Controls

- **Req 2 (TLS Enforcement)**: Enforced via parameter groups (`rds.force_ssl` or `require_secure_transport`).
- **Req 5 (Least Privilege)**: Integration with IAM Database Authentication.
- **Req 7 (Custom Master User)**: Defaulted to `dbadmin` to avoid common `admin/root` names.
- **Req 14 (Complex Passwords)**: Recommended integration with AWS Secrets Manager.
- **Req 3.50-01 (Encryption)**: KMS mandatory for all storage.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- TROUBLESHOOTING -->
## Troubleshooting

### Connection Timeouts

- Verify the Security Group allows traffic on the configured port (default 5432 for Postgres).
- Ensure the calling resource is in a VPC subnet that can route to the database subnets.

### IAM Auth Failures

- Ensure the database user has been created within the DB engine with `rds_iam` role.
- Verify the client IAM policy allows `rds-db:connect`.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/telekom-mms/terraform-aws-rds.svg?style=for-the-badge
[contributors-url]: https://github.com/telekom-mms/terraform-aws-rds/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/telekom-mms/terraform-aws-rds.svg?style=for-the-badge
[forks-url]: https://github.com/telekom-mms/terraform-aws-rds/network/members
[stars-shield]: https://img.shields.io/github/stars/telekom-mms/terraform-aws-rds.svg?style=for-the-badge
[stars-url]: https://github.com/telekom-mms/terraform-aws-rds/stargazers
[issues-shield]: https://img.shields.io/github/issues/telekom-mms/terraform-aws-rds.svg?style=for-the-badge
[issues-url]: https://github.com/telekom-mms/terraform-aws-rds/issues
[license-shield]: https://img.shields.io/github/license/telekom-mms/terraform-aws-rds.svg?style=for-the-badge
[license-url]: https://github.com/telekom-mms/terraform-aws-rds/blob/master/LICENSE.txt
