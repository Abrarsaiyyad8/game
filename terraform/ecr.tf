resource "aws_ecr_repository" "game_repo" {
  name = "browser-game-frontend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "browser-game-frontend"
  }
}

resource "aws_ecr_repository" "game_repo_secound" {
  name = "browser-game-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "browser-game-backend"
  }
}
