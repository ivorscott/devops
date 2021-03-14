provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "example" {
  ami = "ami-0e0102e3ff768559b"
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-training"
  }
}