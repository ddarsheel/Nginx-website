resource "aws_iam_role" "ec2_role" {
  name = var.ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role      = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_pair_name
  security_groups     = [var.security_group_id]
  subnet_id           = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update
    apt-get install -y docker.io python3-pip || { echo "Failed to install packages"; exit 1; }

    systemctl start docker
    systemctl enable docker

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    apt install unzip

    unzip -u awscliv2.zip
    ./aws/install

    aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_repository_url} || { echo "Failed to login to ECR"; exit 1; }

    docker pull ${var.ecr_repository_url}:latest || { echo "Failed to pull Docker image"; exit 1; }

    docker run -d -p 80:80 --name nginx-web ${var.ecr_repository_url}:latest || { echo "Failed to run Docker container"; exit 1; }
  EOF

  tags = {
    Name = "test-ec2"
  }

  lifecycle {
    create_before_destroy = true
  }
}
