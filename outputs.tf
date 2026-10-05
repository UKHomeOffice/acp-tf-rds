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

output "debug_dns_zone" {
  value = var.dns_zone
}

output "org_moniker" {
  value = var.org_moniker
}

output "dns_zone_id" {
  value       = var.org_moniker != "cc" ? try(data.aws_route53_zone.selected[0].id, "") : var.dns_zone_id
  description = "The Route53 zone ID used for DNS records"
}
