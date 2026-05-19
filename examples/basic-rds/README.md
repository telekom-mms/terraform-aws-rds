# AWS RDS Basic Example

This example demonstrates how to use the AWS RDS module to create a basic PostgreSQL RDS instance.

## Features

- PostgreSQL RDS instance
- Uses existing VPC, subnets, and security groups (default VPC if available)
- Encrypted storage
- Automated backups

## Usage

1.  Copy this example to your project.
2.  Update `variables.tf` with your specific values, especially `db_password`.
3.  Ensure you have a default VPC, subnets, and security groups, or modify `main.tf` to reference your existing network resources.
4.  Initialize and apply:
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

## Variables

See `variables.tf` for all configurable options.

## Outputs

- `db_instance_id`: Identifier of the created RDS instance.
- `db_instance_endpoint`: Endpoint of the created RDS instance.

## Requirements

- AWS CLI configured
- Terraform >= 1.0
