resource "aws_key_pair" "einstein_key" {
  key_name   = "terraform"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.einstein_key.key_name
  vpc_security_group_ids = [ aws_security_group.webSG.id ]

  tags = {
    Name = "nodeNginxProxyWebServer"
  }

  # provisioner "file" {
  #   source = "cert"
  #   destination = "/tmp"
  # }
  # provisioner "file" {
  #   source = "conf_files"
  #   destination = "/tmp"
  # }

  provisioner "file" {
    source = "./scripts/install.sh"
    destination = "/home/ubuntu/install.sh"
  }

  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod a+x install.sh",
       "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh",  # Remove the spurious CR characters.
      "./install.sh"
    ]
  }
}


resource "aws_security_group" "webSG" {
  name        = "webSG"
  description = "Allow ssh  inbound traffic"

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

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
}