module "sg_redis" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_gitlab_redis"
  description = "Security group for redis and gitlab."
  vpc_id      = data.aws_subnet.subnet.vpc_id

  # ingress
  ingress_with_source_security_group_id = [
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      description              = "Traffic between gitlab and redis"
      source_security_group_id = module.sg_internet_gitlab.security_group_id
    }
  ]

  tags = merge(var.tags, tomap({
    "Name" = "Gitlab Redis"
  }))
}

resource "aws_elasticache_subnet_group" "gitlab" {
  name       = "gitlab-cache-subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "gitlab" {
  cluster_id           = "cluster-gitlab"
  engine               = "redis"
  node_type            = var.redis_instance_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  security_group_ids   = [module.sg_redis.security_group_id]
  subnet_group_name    = aws_elasticache_subnet_group.gitlab.name

  tags = merge(var.tags, tomap({
    "Name" = "Gitlab Redis Cluster"
  }))
}