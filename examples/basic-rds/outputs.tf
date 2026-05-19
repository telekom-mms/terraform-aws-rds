// examples/basic-rds/outputs.tf

output "db_instance_id" {
  description = "RDS instance identifier"
  value       = module.rds_instance.db_instance_id
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds_instance.db_instance_endpoint
}
