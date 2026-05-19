// outputs.tf

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = try(aws_db_instance.this[0].id, null)
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.this[0].arn, null)
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = try(aws_db_instance.this[0].endpoint, null)
}

output "cluster_id" {
  description = "The ID of the Aurora cluster"
  value       = try(aws_rds_cluster.this[0].id, null)
}

output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = try(aws_rds_cluster.this[0].endpoint, null)
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = try(aws_rds_cluster.this[0].reader_endpoint, null)
}

output "db_proxy_id" {
  description = "The ID of the RDS Proxy"
  value       = try(aws_db_proxy.this[0].id, null)
}

output "db_proxy_endpoint" {
  description = "The endpoint of the RDS Proxy"
  value       = try(aws_db_proxy.this[0].endpoint, null)
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = var.create_kms_key ? aws_kms_key.rds[0].arn : var.kms_key_id
}
