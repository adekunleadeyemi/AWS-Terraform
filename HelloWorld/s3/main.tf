terraform {
  required_version = ">= 0.11"
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_db_instance" "myrds" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "my_tunde_test_name"
  username            = "admin"
  password            = "${var.db_password}"
  skip_final_snapshot = true
  publicly_accessible = true
}
