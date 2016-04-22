# vim: set ft=terraform:

provider "aws" {
  region = "us-west-1"
}

# firewall rules
resource "aws_security_group" "default" {
  # outbound trafic
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
    from_port = 0
    to_port = 0
  }

  # ssh
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    from_port = 22
    to_port = 22
  }

  # http
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    from_port = 80
    to_port = 80
  }
}

# SSH key pair
resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

# static ip
resource "aws_eip" "web" {
  instance = "${aws_instance.web.id}"
}

# single free tier EC2 instance
resource "aws_instance" "web" {
  # basic VM info
  ami = "ami-06116566"
  instance_type = "t2.micro"

  # security
  key_name = "${aws_key_pair.auth.id}"
  security_groups = ["${aws_security_group.default.name}"]
  connection {
    user = "ubuntu"
  }

  # puppet
  provisioner "file" {
    source = "puppet"
    destination = "/home/ubuntu"
  }
  provisioner "remote-exec" {
    scripts = [
      "scripts/install-puppet.sh",
      "scripts/setup-puppet.sh"
    ]
  }
}
