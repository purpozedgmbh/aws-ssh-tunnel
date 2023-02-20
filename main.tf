terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_ami" "linux" {
  owners           = ["amazon"]
  executable_users = ["all"]
  most_recent      = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

data "aws_key_pair" "cto" {
  key_name = var.key_pair_name
}

resource "aws_instance" "bastion" {

  ami                    = data.aws_ami.linux.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = var.public_subnet_id
  security_groups = setunion([aws_security_group.bastion.id], var.security_group_ids)

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id
  name_prefix = "bastion-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_route53_record" "bastion_domain" {
  zone_id = var.rote53_zone_id
  name    = local.bastion_domain
  type    = "A"
  ttl     = "300"

  records = [aws_instance.bastion.public_ip]
}
