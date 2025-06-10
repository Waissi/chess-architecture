resource "aws_launch_template" "chess_server_lt" {
  name_prefix   = "chess_server_lt"
  image_id      = "ami-02b7d5b1e55a7b5f1"
  instance_type = "t2.micro"
  iam_instance_profile {
    name = "ec2_instance_role_profile"
  }
  vpc_security_group_ids = [aws_security_group.chess_server_sg.id]
  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker
usermod -a -G docker ec2-user
service docker start
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 418272756884.dkr.ecr.eu-central-1.amazonaws.com
docker run --rm -p 6789:6789/udp -p 80:80 418272756884.dkr.ecr.eu-central-1.amazonaws.com/chess-server:latest
rm /var/lib/cloud/instances/*/sem/config_scripts_user
EOF
  )

}

resource "aws_autoscaling_group" "asg" {
  depends_on       = [aws_instance.chess_allocator]
  name             = "chess-server-asg"
  desired_capacity = 1
  max_size         = 4
  min_size         = 1
  launch_template {
    id      = aws_launch_template.chess_server_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = data.aws_subnets.default_vpc_subnets.ids
  target_group_arns   = [aws_lb_target_group.chess_server_tg.arn]
}
