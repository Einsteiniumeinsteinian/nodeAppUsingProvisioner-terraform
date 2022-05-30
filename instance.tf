resource "aws_key_pair" "einstein_key" {
  key_name   = "terraform"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.einstein_key.key_name

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
    source = "install.sh"
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



#security Group
#Vpc
#key pairs
#connect to vm 