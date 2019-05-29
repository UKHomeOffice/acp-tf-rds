output "instance_id" {
  value       = "${join("", aws_db_instance.db_including_name.*.id)}"
  description = "ID of the instance"
}
