## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| allocated\_storage | The allocated storage in GBs for the RDS | `any` | n/a | yes |
| allow\_major\_version\_upgrade | Allow major version upgrade | `bool` | `false` | no |
| auto\_minor\_version\_upgrade | Allow automated minor version upgrade | `bool` | `false` | no |
| backup\_retention\_period | How long will we retain backups | `string` | `0` | no |
| backup\_window | When AWS can run snapshot, can't overlap with maintenance window | `string` | `"22:00-03:00"` | no |
| ca\_cert\_identifier | The identifier of the CA certificate for the DB instance. | `any` | n/a | yes |
| cidr\_blocks | A list of network cidr block which are permitted acccess | `list` | <code><pre>[<br>  "0.0.0.0/0"<br>]<br></pre></code> | no |
| copy\_tags\_to\_snapshot | Copy tags from DB to a snapshot | `bool` | `true` | no |
| database\_name | The name of the database to create | `string` | `""` | no |
| database\_password | The default password for the specified user for RDS | `any` | n/a | yes |
| database\_port | The database port being used by the RDS instance, i.e. 3306, 5342 | `any` | n/a | yes |
| database\_user | The username for the RDS to be created | `string` | `"root"` | no |
| db\_cluster\_parameter\_family | Cluster parameter group, depends on DB engine used | `string` | `""` | no |
| db\_cluster\_parameters | A map of database parameters for the RDS Cluster instance | `list` | `[]` | no |
| db\_parameter\_family | Parameter group, depends on DB engine used | `any` | n/a | yes |
| db\_parameters | A map of database parameters for the RDS instance | `list` | `[]` | no |
| dns\_name | The dns name added the dns zone, else defaults to var.name | `string` | `""` | no |
| dns\_ttl | The dns record type for the RDS instance, defaults to CNAME | `string` | `"300"` | no |
| dns\_type | The dns record type for the RDS instance, defaults to CNAME | `string` | `"CNAME"` | no |
| dns\_zone | The required route53 domain name we are added the dns entry to i.e. example.com | `any` | n/a | yes |
| engine\_type | Database engine type | `any` | n/a | yes |
| engine\_version | Database engine version, depends on engine type | `any` | n/a | yes |
| environment | The environment the RDS is running in i.e. dev, prod etc | `any` | n/a | yes |
| instance\_class | Class of RDS instance | `string` | `"db.t2.medium"` | no |
| is\_multi\_az | Set to true on production | `bool` | `false` | no |
| license\_model | License model information required for some DBs like Oracle SE2 | `string` | `""` | no |
| log\_access\_enabled | Create a user with access to the instance's logs | `bool` | `false` | no |
| management\_access\_enabled | Create a user that can start/stop RDS and get logs with AWS CLI | `bool` | `false` | no |
| name | A descriptive name for the RDS instance (leave blank only when rds requires it to be blank) | `any` | n/a | yes |
| number\_of\_aurora\_instances | The number of Aurora instances to create | `number` | `1` | no |
| publicly\_accessible | If true, the RDS will be publicly accessible | `bool` | `false` | no |
| replicate\_source\_db | Specifies that this resource is a Replicate database, and to use this value as the source database. | `string` | `""` | no |
| skip\_final\_snapshot | If true (false by default), no snapshot will be made before deleting DB | `bool` | `false` | no |
| storage\_encrypted | Indicates you want the underlining storage to be encrypted | `bool` | `true` | no |
| storage\_type | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). | `string` | `"gp2"` | no |
| subnet\_group\_name | The name/ID of the subnet group for the instance | `string` | `""` | no |
| subnet\_ids | The list of subnet IDs associated to a vpc | `list` | `[]` | no |
| subnet\_role | A role used to filter out which subnets the RDS should reside, defaults to Role=compute | `string` | `"compute"` | no |
| tags | A map of tags to add to all resources | `map` | `{}` | no |
| vpc\_id | The VPC ID to create the resources within | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_excluding\_name\_instance\_id | ID of the instance |
| db\_including\_name\_instance\_id | ID of the instance |

