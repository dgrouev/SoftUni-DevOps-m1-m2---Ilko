provider "aws" {
  access_key = "AKIA3MME3HK3QA5XHXTE"
  secret_key = "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"
  region     = "eu-central-1"
}

resource "aws_vpc" "hw-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "HW-VPC"
  }
}

resource "aws_internet_gateway" "hw-igw" {
  vpc_id = aws_vpc.hw-vpc.id
  tags = {
    Name = "HW-IGW"
  }
}

resource "aws_route_table" "hw-prt" {
  vpc_id = aws_vpc.hw-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hw-igw.id
  }
  tags = {
    Name = "HW-PUBLIC-PRT"
  }
}

resource "aws_subnet" "hw-snet" {
  vpc_id                  = aws_vpc.hw-vpc.id
  cidr_block              = "10.10.10.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "HW-SUB-NET"
  }
}

resource "aws_route_table_association" "hw-prt-assoc" {
  subnet_id      = aws_subnet.hw-snet.id
  route_table_id = aws_route_table.hw-prt.id
}

resource "aws_security_group" "hw-pub-sg" {
  name        = "hw-pub-sg"
  description = "HW Public SG"
  vpc_id      = aws_vpc.hw-vpc.id
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
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.10.10.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "hw-web-net" {
  subnet_id       = aws_subnet.hw-snet.id
  private_ips     = ["10.10.10.100"]
  security_groups = [aws_security_group.hw-pub-sg.id]

  tags = {
    Name = "HW-WEB-PRIVATE-IP"
  }
}

resource "aws_network_interface" "hw-db-net" {
  subnet_id       = aws_subnet.hw-snet.id
  private_ips     = ["10.10.10.101"]
  security_groups = [aws_security_group.hw-pub-sg.id]

  tags = {
    Name = "HW-DB-PRIVATE-IP"
  }
}

resource "aws_instance" "hw-web" {
  ami           = "ami-0dcc0ebde7b2e00db"
  instance_type = "t2.micro"
  key_name      = "terraform-aws"

  network_interface {
    network_interface_id = aws_network_interface.hw-web-net.id
    device_index         = 0
  }

  provisioner "file" {
    source      = "./provision-web.sh"
    destination = "/tmp/provision-web.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("c:/keys/terraform-aws.pem")
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision-web.sh",
      "/tmp/provision-web.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("c:/keys/terraform-aws.pem")
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "hw-db" {
  ami           = "ami-0dcc0ebde7b2e00db"
  instance_type = "t2.micro"
  key_name      = "terraform-aws"

  network_interface {
    network_interface_id = aws_network_interface.hw-db-net.id
    device_index         = 0
  }

  provisioner "file" {
    source      = "./provision-db.sh"
    destination = "/tmp/provision-db.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("c:/keys/terraform-aws.pem")
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision-db.sh",
      "/tmp/provision-db.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("c:/keys/terraform-aws.pem")
      host        = self.public_ip
    }
  }
}

output "web_app_public_ip" {
  value = aws_instance.hw-web.public_ip
}
