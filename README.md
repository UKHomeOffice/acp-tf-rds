Module usage:

     module "rds" {
        source                = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=master"

        name                         = "fake"
        allocated_storage            = "20"
        cidr_blocks                  = ["${values(var.compute.cidrs)}"]
        database_name                = "keycloak"
        database_password            = "password"
        database_port                = "3306"
        database_user                = "root"
        db_parameter_family          = "default.mysql5.6"
        dns_zone                     = "${var.dns\_zone}"
        engine_type                  = "MariaDB"
        engine_version               = "10.1.19"
        environment                  = "${var.environment}"
        instance_class               = "db.t2.medium"
        max_allocated_storage        = 100
        performance_insights_enabled = true

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.db_excluding_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.db_including_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_instance.db_read_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_policy.rds_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rds_management_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.rds_performance_insights_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.rds_logs_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.rds_management_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.rds_performance_insights_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.rds_log_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.rds_management_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.rds_performance_insights_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_rds_cluster.aurora_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.aurora_cluster_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_route53_record.dns_excluding_dbname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dns_including_dbname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dns_read_replica_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.database_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.out_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in GBs for the RDS | `any` | n/a | yes |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Allow major version upgrade | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Allow automated minor version upgrade | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | How long will we retain backups | `string` | `0` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | When AWS can run snapshot, can't overlap with maintenance window | `string` | `"22:00-03:00"` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | A list of network cidr block which are permitted acccess | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Copy tags from DB to a snapshot | `bool` | `true` | no |
| <a name="input_custom_option_group_name"></a> [custom\_option\_group\_name](#input\_custom\_option\_group\_name) | Name of custom option group for RDS instance | `string` | `""` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the database to create | `string` | `""` | no |
| <a name="input_database_password"></a> [database\_password](#input\_database\_password) | The default password for the specified user for RDS | `any` | n/a | yes |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | The database port being used by the RDS instance, i.e. 3306, 5342 | `any` | n/a | yes |
| <a name="input_database_user"></a> [database\_user](#input\_database\_user) | The username for the RDS to be created | `string` | `"root"` | no |
| <a name="input_db_cluster_parameter_family"></a> [db\_cluster\_parameter\_family](#input\_db\_cluster\_parameter\_family) | Cluster parameter group, depends on DB engine used | `string` | `""` | no |
| <a name="input_db_cluster_parameters"></a> [db\_cluster\_parameters](#input\_db\_cluster\_parameters) | A map of database parameters for the RDS Cluster instance | `list` | `[]` | no |
| <a name="input_db_parameter_family"></a> [db\_parameter\_family](#input\_db\_parameter\_family) | Parameter group, depends on DB engine used | `any` | n/a | yes |
| <a name="input_db_parameters"></a> [db\_parameters](#input\_db\_parameters) | A map of database parameters for the RDS instance | `list` | `[]` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | The dns name added the dns zone, else defaults to var.name | `string` | `""` | no |
| <a name="input_dns_ttl"></a> [dns\_ttl](#input\_dns\_ttl) | The dns record type for the RDS instance, defaults to CNAME | `string` | `"300"` | no |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | The dns record type for the RDS instance, defaults to CNAME | `string` | `"CNAME"` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | The required route53 domain name we are added the dns entry to i.e. example.com | `any` | n/a | yes |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | A list of email addresses for key rotation notifications. | `list` | `[]` | no |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | Database engine type | `any` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database engine version, depends on engine type | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the RDS is running in i.e. dev, prod etc | `any` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Class of RDS instance | `string` | `"db.t2.medium"` | no |
| <a name="input_is_multi_az"></a> [is\_multi\_az](#input\_is\_multi\_az) | Set to true on production | `bool` | `false` | no |
| <a name="input_key_rotation"></a> [key\_rotation](#input\_key\_rotation) | Enable email notifications for old IAM keys. | `string` | `"true"` | no |
| <a name="input_license_model"></a> [license\_model](#input\_license\_model) | License model information required for some DBs like Oracle SE2 | `string` | `""` | no |
| <a name="input_log_access_enabled"></a> [log\_access\_enabled](#input\_log\_access\_enabled) | Create a user with access to the instance's logs | `bool` | `false` | no |
| <a name="input_management_access_enabled"></a> [management\_access\_enabled](#input\_management\_access\_enabled) | Create a user that can start/stop RDS and get logs with AWS CLI | `bool` | `false` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | The maximum allocated storage that is allowed for an RDS instance. | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | A descriptive name for the RDS instance (leave blank only when rds requires it to be blank) | `any` | n/a | yes |
| <a name="input_number_of_aurora_instances"></a> [number\_of\_aurora\_instances](#input\_number\_of\_aurora\_instances) | The number of Aurora instances to create | `number` | `1` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Create a user that can access PI with AWS CLI | `bool` | `false` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | If Long Term Retention is turned off, performance data older than 7 days is deleted | `any` | `null` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | If true, the RDS will be publicly accessible | `bool` | `false` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replicate database, and to use this value as the source database. | `string` | `""` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | If true (false by default), no snapshot will be made before deleting DB | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Indicates you want the underlining storage to be encrypted | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). | `string` | `"gp2"` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | The name/ID of the subnet group for the instance | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnet IDs associated to a vpc | `list` | `[]` | no |
| <a name="input_subnet_role"></a> [subnet\_role](#input\_subnet\_role) | A role used to filter out which subnets the RDS should reside, defaults to Role=compute | `string` | `"compute"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to create the resources within | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_excluding_name_instance_id"></a> [db\_excluding\_name\_instance\_id](#output\_db\_excluding\_name\_instance\_id) | ID of the instance |
| <a name="output_db_including_name_instance_id"></a> [db\_including\_name\_instance\_id](#output\_db\_including\_name\_instance\_id) | ID of the instance |
| <a name="output_rds_security_group_id"></a> [rds\_security\_group\_id](#output\_rds\_security\_group\_id) | ID of security group |
