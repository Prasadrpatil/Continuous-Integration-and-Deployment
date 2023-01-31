provider "aws" {
  region = var.AWS_REGION
  access_key= ""
  secret_key= ""
}


resource "aws_instance" "web" {
  ami           = "ami-098e42ae54c764c35"
  instance_type = "t2.micro"
  tags= {
    Environment = "dev"
    Project = "Fresher Training"
    Name = "Prasad_Assignment-10"
  }
}