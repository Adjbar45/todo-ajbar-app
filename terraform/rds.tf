resource "aws_db_subnet_group" "todo_db_subnet_group" {
  name       = "todo-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "todo-db-subnet-group"
  }
}

resource "aws_db_instance" "todo_db" {
  identifier             = "todo-app-db"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro" # free-tier eligible
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.todo_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "todo-app-db"
  }
}
