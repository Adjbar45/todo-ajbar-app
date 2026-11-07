# Use the default VPC to keep this beginner-friendly
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group for the EC2 instance running the app
resource "aws_security_group" "web_sg" {
  name        = "todo-app-web-sg"
  description = "Allow SSH, HTTP app port"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "App port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "todo-app-web-sg"
  }
}

# Security group for RDS - only allow traffic from the web security group
resource "aws_security_group" "db_sg" {
  name        = "todo-app-db-sg"
  description = "Allow Postgres traffic only from the app server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Postgres from web server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "todo-app-db-sg"
  }
}
