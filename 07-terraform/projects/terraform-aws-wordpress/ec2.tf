resource "aws_security_group" "wordpress" {
  name        = "${var.project_name}-sg"
  description = "Allow inbound HTTP and outbound traffic for WordPress"
  vpc_id      = aws_vpc.wordpress.id

  tags = { Name = "${var.project_name}-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.wordpress.id
  cidr_ipv4         = var.http_ingress_cidr
  from_port         = var.http_port
  to_port           = var.http_port
  ip_protocol       = "tcp"
  description       = "Allow HTTP access to WordPress"
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.wordpress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound traffic for package downloads and updates"
}

resource "aws_instance" "wordpress" {
  ami                         = coalesce(var.ami_id, data.aws_ssm_parameter.amazon_linux_2023_ami.value)
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.wordpress.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/wordpress.sh")

  tags = { Name = "${var.project_name}-server" }

  depends_on = [
    aws_route_table_association.public,
    aws_vpc_security_group_ingress_rule.http,
    aws_vpc_security_group_egress_rule.all_ipv4
  ]
}
