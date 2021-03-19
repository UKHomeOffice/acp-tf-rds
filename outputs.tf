output "db_including_name_instance_id" {
  value       = join("", aws_db_instance.db_including_name.*.id)
  description = "ID of the instance"
}

output "db_excluding_name_instance_id" {
  value       = join("", aws_db_instance.db_excluding_name.*.id)
  description = "ID of the instance"
}

output "rds_security_group_id" {
  value       = aws_security_group.db.id
  description = "ID of security group"
}
