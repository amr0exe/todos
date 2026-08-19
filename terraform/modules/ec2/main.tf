data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_security_group" "ec2-sg" {
  name        = "rem-ec2-sg"
  description = "allow inbound http ssh ping"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# config to make ECR pull posible
resource "aws_iam_role" "this" {
  count = 2
  name  = "rem-ec2-${count.index + 1}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "ecr_pull" {
  count = 2
  name  = "ecr-pull"
  role  = aws_iam_role.this[count.index].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "this" {
  count = 2
  name  = "rem-ec2-${count.index + 1}"
  role  = aws_iam_role.this[count.index].name
}

# --

resource "aws_instance" "tweb" {
  count = 2

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  iam_instance_profile        = aws_iam_instance_profile.this[count.index].name
  associate_public_ip_address = true


  tags = merge(var.tags, {
    Name        = "rem-ec2-${count.index + 1}"
    Environment = var.environment
  })
}

resource "aws_lb_target_group" "tg-ect" {
  name        = "rem-ec2-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group" "backend" {
  name        = "rem-backend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/api/healthz"
    protocol            = "HTTP"
    port                = "3000"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
  }
}

resource "aws_lb_target_group_attachment" "tg-att" {
  count            = length(aws_instance.tweb)
  target_group_arn = aws_lb_target_group.tg-ect.arn
  target_id        = aws_instance.tweb[count.index].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "backend" {
  count = length(aws_instance.tweb)

  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = aws_instance.tweb[count.index].id
  port             = 3000
}
