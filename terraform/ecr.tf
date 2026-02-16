resource "aws_ecr_repository" "game_repo" {
  name = "browser-game"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "browser-game-repo"
  }
}
