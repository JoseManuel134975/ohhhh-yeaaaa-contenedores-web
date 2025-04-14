resource "aws_instance" "fedora" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = "${var.aws_region}a"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_http_and_ssh.id]
  user_data              = file("user_data.sh")
  key_name = aws_key_pair.fedora.key_name

  tags = {
    Name = "${var.name}"
  }
}