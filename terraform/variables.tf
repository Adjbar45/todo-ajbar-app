variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "todouser"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "tododb"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro" # free-tier eligible
}

variable "key_pair_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

variable "my_ip" {
  description = "Your IP address in CIDR notation, e.g. 1.2.3.4/32 (for SSH access)"
  type        = string
}
