resource "aws_vpc" "lab-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "lab-vpc"
  }
}

resource "aws_subnet" "lab-subnet" {
  vpc_id     = aws_vpc.lab-vpc.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "lab-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.lab-vpc.id

  tags = {
    Name = "gw"
  }
}

resource "aws_route_table" "lab-rt" {
  vpc_id = aws_vpc.lab-vpc.id

  route {
    cidr_block = var.subnet_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.lab-subnet.id
  route_table_id = aws_route_table.lab-rt.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow ssh"
  description = "Allow ssh inbound traffic port 22 and all outbound traffic"
  vpc_id      = aws_vpc.lab-vpc.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = aws_vpc.lab-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "ssh"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "web" {
  ami           = "data.aws_ami.ubuntu.id"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.lab-subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "lab-ec2"
  }
}


