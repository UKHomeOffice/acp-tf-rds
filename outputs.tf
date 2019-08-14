output "db_including_name_instance_id" {
  value       = join("", aws_db_instance.db_including_name.*.id)
  description = "ID of the instance"
}

output "db_excluding_name_instance_id" {
  value       = join("", aws_db_instance.db_excluding_name.*.id)
  description = "ID of the instance"
}

