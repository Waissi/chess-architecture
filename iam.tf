resource "aws_iam_role" "ip_provider_role" {
  name = "ip_provider_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "lambda_db_role" {
  name = "lambda_db_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_ec2" {
  role       = aws_iam_role.ip_provider_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_lambda_to_ip_provider" {
  role       = aws_iam_role.ip_provider_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_lambda_to_save_to_db" {
  role       = aws_iam_role.lambda_db_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "role_policy_attachment_dynamo_to_save_to_db" {
  role       = aws_iam_role.lambda_db_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_ec2_instance" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_instance_profile" "ip_provider_role_profile" {
  name = "ip_provider_role_profile"
  role = aws_iam_role.ip_provider_role.name
}

resource "aws_iam_instance_profile" "lambda_db_role_profile" {
  name = "lambda_db_role_profile"
  role = aws_iam_role.lambda_db_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_role_profile" {
  name = "ec2_instance_role_profile"
  role = aws_iam_role.ec2_instance_role.name
}
