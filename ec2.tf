resource "aws_instance" "chess_allocator" {
  key_name               = "macbook"
  ami                    = "ami-02b7d5b1e55a7b5f1"
  vpc_security_group_ids = [aws_security_group.chess_allocator_sg.id]
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_role_profile.name
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install -y docker
usermod -a -G docker ec2-user
service docker start
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 418272756884.dkr.ecr.eu-central-1.amazonaws.com
docker run --rm -p 6790:6790/udp 418272756884.dkr.ecr.eu-central-1.amazonaws.com/chess-allocator:latest
rm /var/lib/cloud/instances/*/sem/config_scripts_user
EOF
  tags = {
    Name = "chess_allocator"
  }
}

resource "aws_instance" "chess_server" {
  depends_on             = [aws_instance.chess_allocator, aws_lambda_function.chess_ip_provider, aws_lambda_function.chess_server_db]
  key_name               = "macbook"
  ami                    = "ami-02b7d5b1e55a7b5f1"
  vpc_security_group_ids = [aws_security_group.chess_server_sg.id]
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_role_profile.name
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install -y docker
usermod -a -G docker ec2-user
service docker start
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 418272756884.dkr.ecr.eu-central-1.amazonaws.com
docker run --rm -p 6789:6789/udp 418272756884.dkr.ecr.eu-central-1.amazonaws.com/chess-server:latest
rm /var/lib/cloud/instances/*/sem/config_scripts_user
  EOF
  tags = {
    Name = "chess_server"
  }
}

