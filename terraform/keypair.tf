resource "aws_key_pair" "game_key" {
  key_name   = "game-key"
  public_key = file("game-key.pub")
}
