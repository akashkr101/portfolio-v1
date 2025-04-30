provider "aws" {
  region     = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/keys/deployer.pub")
}

resource "aws_security_group" "allow_9000" {
  name        = "allow_9000"
  description = "Allow port 9000"

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "docker_vm" {
  ami           = "ami-0e35ddab05955cf57" # Amazon Linux 2
  instance_type = "t2.medium"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.allow_9000.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              docker run -d -p 9000:9000 portainer/portainer-ce
              EOF

  tags = {
    Name = "DockerVM"
  }
}
