module "ecr" {
  source               = "./modules/ecr"
  aws_region           = "us-east-1"
  repository_name      = "lendaread_ecr"
  image_tag_mutability = "MUTABLE"
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = "lendaread_cluster"
  task_family        = "lendaread-tasks"
  aws_region         = "us-east-1"
  subnets            = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]
  security_groups    = [aws_security_group.lendaread_api_task_sg.id]
  repository_url     = module.ecr.repository_url
  lb_dns_name        = module.alb.alb_dns_name
  db_endpoint        = aws_db_instance.lendaread_db.endpoint
  db_username        = aws_db_instance.lendaread_db.username
  db_password        = aws_db_instance.lendaread_db.password
  tg_arn             = module.alb.tg_arn
  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = aws_vpc.lendaread_vpc.id
  public_subnets    = [aws_subnet.subnet_public1.id, aws_subnet.subnet_public2.id]
  alb_name          = "lendaread-alb"
  target_group_name = "lendaread-tg"
  health_check_path = "/"
  tags = {
    Name = "lendaread-alb"
  }
}

module "rds" {
  source                 = "./modules/rds"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.1"
  username               = "postgres"
  password               = "132holastf#"
  subnet_ids             = [aws_subnet.subnet_db1.id, aws_subnet.subnet_db2.id]
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags = {
    Name = "My PostgreSQL Instance"
  }
}

