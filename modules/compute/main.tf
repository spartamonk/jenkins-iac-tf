data "aws_ami" "aws-linux" {
  most_recent = true
  name_regex  = "137112412989"
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20241217.0-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  for_each      = var.instances
  ami           = data.aws_ami.aws-linux.id
  instance_type = each.value.instance_type
  associate_public_ip_address = each.value.public_ip

  tags = {
    Name = "${terraform.workspace}-${each.key}"
  }
}