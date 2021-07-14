module "sg_postgres" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_postgres_gitlab"
  description = "Security group for postgres and gitlab."
  vpc_id      = data.aws_subnet.subnet.vpc_id

  # ingress
  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      description              = "Traffic between gitlab and postgres"
      source_security_group_id = module.sg_internet_gitlab.security_group_id
    }
  ]

  tags = merge(var.tags, tomap({
    "Name" = "sg_postgres_gitlab"
  }))
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "3.2"

  identifier = "gitlab-postgress"

  create_db_option_group    = false
  create_db_parameter_group = false

  engine         = "postgres"
  engine_version = "12.7"
  family         = "postgres12" # DB parameter group

  instance_class    = var.postgres_instance_type
  allocated_storage = 20

  name     = "gitlab"
  username = var.db_username
  password = var.db_password
  port     = 5432

  multi_az               = false
  subnet_ids             = var.private_subnet_ids
  vpc_security_group_ids = [module.sg_postgres.security_group_id]
  tags = merge(var.tags, tomap({
    "Name" = "Gitlab PostgreSQL",
  }))
}