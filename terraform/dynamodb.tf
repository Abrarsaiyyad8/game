resource "aws_dynamodb_table" "game_table" {
  name         = "game-scores"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  tags = {
    Name = "game-scores-table"
  }
}
