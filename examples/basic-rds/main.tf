// examples/basic-rds/main.tf

provider "aws" {
  region = "eu-central-1"
}

# Data sources for existing resources
data "aws_vpc" "existing" {
  default = true
}

data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_security_groups" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

module "rds_instance" {
  source = "../../"

  name_prefix = var.name_prefix

  subnet_ids         = data.aws_subnets.existing.ids
  security_group_ids = [data.aws_security_groups.existing.ids[0]] # Using the first available SG
  master_password    = var.db_password

  engine            = "postgres"
  engine_version    = "13.13"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  tags = var.tags
}
