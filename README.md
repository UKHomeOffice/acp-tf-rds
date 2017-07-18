Module usage:

     module "some_rds" {
       source         = "git::https://github.com/UKHomeOffice/acp-tf-rds?ref=master"

       name            = "my_rds_name"
       environment     = "dev"            # by default both Name and Env is added to the tags
       dns_zone        = "example.com"
       cidr_access     = [ "var.cidr_access" ] # a list of cidr to permit access (defaults 0.0.0.0/0)
       tags            = {
         Role = "some_tag"
       }
     }



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allocated_storage | The allocated storage in GBs for the RDS | string | - | yes |
| allow_major_version_upgrade | Allow major version upgrade | string | `false` | no |
| auto_minor_version_upgrade | Allow automated minor version upgrade | string | `true` | no |
| backup_retention_period | How long will we retain backups | string | `0` | no |
| backup_window | When AWS can run snapshot, can't overlap with maintenance window | string | `22:00-03:00` | no |
| cidr_blocks | A list of network cidr block which are permitted acccess | string | `<list>` | no |
| copy_tags_to_snapshot | Copy tags from DB to a snapshot | string | `true` | no |
| database_name | The name of the database to create | string | - | yes |
| database_password | The default password for the specified user for RDS | string | - | yes |
| database_port | The database port being used by the RDS instance, i.e. 3306, 5342 | string | - | yes |
| database_user | The username for the RDS to be created | string | `root` | no |
| db_parameter_family | Parameter group, depends on DB engine used | string | - | yes |
| db_parameters | A map of database parameters for the RDS instance | string | `<map>` | no |
| dns_name | The dns name added the dns zone, else defaults to var.name | string | `` | no |
| dns_ttl | The dns record type for the RDS instance, defaults to CNAME | string | `CNAME` | no |
| dns_type | The dns record type for the RDS instance, defaults to CNAME | string | `CNAME` | no |
| dns_zone | The required route53 domain name we are added the dns entry to i.e. example.com | string | - | yes |
| engine_type | Database engine type | string | - | yes |
| engine_version | Database engine version, depends on engine type | string | - | yes |
| environment | The environment the RDS is running in i.e. dev, prod etc | string | - | yes |
| instance_class | Class of RDS instance | string | - | yes |
| is_multi_az | Set to true on production | string | `false` | no |
| name | A descriptive name for the RDS instance | string | - | yes |
| skip_final_snapshot | If true (default), no snapshot will be made before deleting DB | string | `true` | no |
| storage_encrypted | Indicates you want the underlining storage to be encrypted | string | `true` | no |
| storage_type | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). | string | `standard` | no |
| subnet_role | A role used to filter out which subnets the RDS should reside, defaults to Role=compute | string | `compute` | no |
| subnets | List of subnets DB should be available at. It might be one subnet. | list | - | yes |
| tags | A map of tags to add to all resources | string | `<map>` | no |

