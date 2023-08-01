# Specify the AWS provider and region
provider "aws" {
  region = "eu-central-1"  # Change this to your desired AWS region
}

# Create an AWS EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0e00e602389e469a3"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Change this to the instance type you want
  key_name      = "lior"

  tags = {
    Name = "TerraInstance"  # Replace with a name for your instance
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"  # Change this to the appropriate user for your AMI
    private_key = file("C:/Users/liorb/OneDrive/Desktop/lior.pem")  # Replace with the correct path to your private key file
    host        = aws_instance.example.public_dns  # Use public DNS name (FQDN) of the instance
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install git -y",
      "sudo yum install docker -y",
      "sudo yum install python3-pip -y",
      "pip3 install docker-compose",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl start docker.service",
      "sudo systemctl enable docker.service",
    ]
  }
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"  # Change this to the appropriate user for your AMI
      private_key = file("C:/Users/liorb/OneDrive/Desktop/lior.pem")  # Replace with the correct path to your private key file
      host        = aws_instance.example.public_dns  # Use public DNS name (FQDN) of the instance
    }

    inline = [
      "git clone https://github.com/liorfizz/ci-cd.git",
      "cd ci-cd/alpacaflask/ && docker-compose up -d",
    ]
  }
}
