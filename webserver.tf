provider "aws" {
  region = "ap-south-1"
  access_key = "AKIAY7FPR3PR53D6NDPD"
  secret_key = "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"
}

# Creating Security Group

resource "aws_security_group" "http-ssh" {
  name = "ssh-http"
  description = "allowing ssh and http traffic"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
#security group ends

#creating ec2 instance

resource "aws_instance" "hello-web-terrs" {
         ami = "ami-06a0b4e3b7eb7a300"
         instance_type = "t2.micro"
         security_groups = ["${aws_security_group.http-ssh.name}"]
         key_name = "terra"
         user_data = <<-EOF
                  #! /bin/bash
                  sudo yum install httpd -y
                  sudo systemctl start httpd
                  sudo systemctl enable httpd
                  echo "<h1>Sample werserver created</h1>" >> /var/www/html/index.html
                  EOF
         tags = {
           "Name" = "webserver"
         }
}