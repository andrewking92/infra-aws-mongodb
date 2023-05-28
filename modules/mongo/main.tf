# Create Route53 record for each EC2 instance
resource "aws_route53_record" "infra-aws-mongo" {
  zone_id = "${var.aws_host_zone_id}"
  name = var.FQDN
  type = "A"
  ttl = "300"
  records = [ aws_instance.infra-aws-mongo.private_ip ]
}


# Create EC2 instance with default root volume
resource "aws_instance" "infra-aws-mongo" {
  ami                     = var.ami
  instance_type           = var.instance_type
  
  subnet_id               = var.subnet_id

  vpc_security_group_ids  = [ var.security_group_id ]
  key_name                = var.key_name

  tags = {
    Name = var.instance_name
  }

  root_block_device {
    volume_size = var.aws_instance_root_block_device_volume_size
  }
}


# Create 10 GB volume
resource "aws_ebs_volume" "infra-aws-mongo" {
  availability_zone = var.aws_availability_zone
  size              = var.aws_ebs_volume_size
}


# Attach volume to EC2 instance
resource "aws_volume_attachment" "infra-aws-mongo" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.infra-aws-mongo.id
  instance_id = aws_instance.infra-aws-mongo.id
  force_detach = true
}


# Ansible Playbooks
resource "null_resource" "infra-aws-mongo" {
  depends_on = [aws_volume_attachment.infra-aws-mongo]

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
        type        = "ssh"
        user        = var.ssh_user
        private_key = file(var.private_key)
        host        = aws_instance.infra-aws-mongo.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.infra-aws-mongo.public_ip}, ./modules/mongo/ansible/playbook.yml -e hostname=${var.FQDN}"
  }
}