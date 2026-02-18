resource "aws_security_group" "game_sg" {
  vpc_id = aws_vpc.game_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "game-security-group"
  }
}

resource "aws_instance" "jenkins" {
  ami           = "ami-019715e0d74f695be"
  instance_type = "m7i-flex.large"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.game_sg.id]
  key_name = aws_key_pair.game_key.key_name
  user_data = file("jenkins_userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-019715e0d74f695be"
  instance_type = "m7i-flex.large"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.game_sg.id]
  key_name = aws_key_pair.game_key.key_name
  user_data = file("app_userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.app_profile.name
  
  tags = {
    Name = "game-app-server"
  }
}


resource "aws_instance" "monitoring" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "m7i-flex.large"
  subnet_id     = aws_subnet.public_subnet.id
   vpc_security_group_ids = [aws_security_group.game_sg.id]
  key_name      = aws_key_pair.game_key.key_name

  tags = {
    Name = "monitoring-server"
  }
}
