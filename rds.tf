data "aws_ssm_parameter" "RDS_PASSWORD" {
  name = "/spada/production/RDS_PASSWORD"  
}

data "aws_ssm_parameter" "RDS_USERNAME" {
  name = "/spada/production/RDS_USERNAME"  
}

data "aws_ssm_parameter" "RDS_DB_NAME" {
  name = "/spada/production/RDS_DB_NAME"  
}

data "aws_ssm_parameter" "RDS_PORT" {
  name = "/spada/production/RDS_PORT"  
}

data "aws_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  name   = "default"
}

resource "aws_security_group_rule" "allow_all" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = data.aws_security_group.default.id
}

# module "rds_instance" {
#   source              = "git::https://github.com/cloudposse/terraform-aws-rds.git?ref=master"
#   namespace           = "eg"
#   stage               = "product"
#   name                = "demodb"
#   database_name       = data.aws_ssm_parameter.RDS_DB_NAME.value
#   database_user       = data.aws_ssm_parameter.RDS_USERNAME.value
#   database_password   = data.aws_ssm_parameter.RDS_PASSWORD.value
#   database_port       = data.aws_ssm_parameter.RDS_PORT.value
#   multi_az            = false
#   storage_type        = "standard"
#   allocated_storage   = 20
#   storage_encrypted   = false
#   engine              = "mysql"
#   engine_version      = "5.7.22"
#   instance_class      = "db.t2.small"
#   db_parameter_group  = "mysql5.7"
#   publicly_accessible = false
#   vpc_id              = module.vpc.vpc_id
#   subnet_ids          = [module.vpc.public_subnet_1a, module.vpc.public_subnet_1b, module.vpc.public_subnet_1c]
#   security_group_ids  = [data.aws_security_group.default.id]
#   apply_immediately   = true

#   db_parameter = [
#     {
#       name         = "myisam_sort_buffer_size"
#       value        = "1048576"
#       apply_method = "immediate"
#     },
#     {
#       name         = "sort_buffer_size"
#       value        = "2097152"
#       apply_method = "immediate"
#     }
#   ]
# }

module "rds_instance" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7.26"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  max_allocated_storage = 10000
  storage_encrypted = false
  multi_az = false

  name     = data.aws_ssm_parameter.RDS_DB_NAME.value
  username = data.aws_ssm_parameter.RDS_USERNAME.value
  password = data.aws_ssm_parameter.RDS_PASSWORD.value
  port     = data.aws_ssm_parameter.RDS_PORT.value

  vpc_security_group_ids = [data.aws_security_group.default.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  backup_retention_period = 0

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
#   monitoring_interval = "30"
#   monitoring_role_name = "MyRDSMonitoringRole"
#   create_monitoring_role = true

  enabled_cloudwatch_logs_exports = ["audit"]

  tags = {
    Owner       = "longhanhee"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = [module.vpc.public_subnet_1a, module.vpc.public_subnet_1b]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "demodb"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8"
    },
    {
      name = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}