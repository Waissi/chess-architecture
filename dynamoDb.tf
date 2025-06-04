resource "aws_dynamodb_table" "chess_server_db" {
  name           = "chess_server_db"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "gameId"
  attribute {
    name = "gameId"
    type = "S"
  }
}

