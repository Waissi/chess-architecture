data "archive_file" "ip_provider_zip" {
  type        = "zip"
  source_file = "lambda/chess_ip_provider.py"
  output_path = "chess_ip_provider.zip"
}

data "archive_file" "server_db_zip" {
  type        = "zip"
  source_file = "lambda/chess_server_db.py"
  output_path = "chess_server_db.zip"
}

resource "aws_lambda_function" "chess_ip_provider" {
  function_name    = "chess_ip_provider"
  filename         = data.archive_file.ip_provider_zip.output_path
  source_code_hash = data.archive_file.ip_provider_zip.output_base64sha256
  handler          = "chess_ip_provider.lambda_handler"
  runtime          = "python3.10"
  timeout          = 5
  role             = aws_iam_role.ip_provider_role.arn
}

resource "aws_lambda_function" "chess_server_db" {
  function_name    = "chess_server_db"
  filename         = data.archive_file.server_db_zip.output_path
  source_code_hash = data.archive_file.server_db_zip.output_base64sha256
  role             = aws_iam_role.lambda_db_role.arn
  handler          = "chess_server_db.lambda_handler"
  timeout          = 5
  runtime          = "python3.10"
}

resource "aws_lambda_function_url" "ip_provider_url" {
  function_name      = aws_lambda_function.chess_ip_provider.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_function_url" "server_db_url" {
  function_name      = aws_lambda_function.chess_server_db.function_name
  authorization_type = "NONE"
}
