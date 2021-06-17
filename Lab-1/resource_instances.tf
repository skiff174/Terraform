resource "aws_launch_configuration" "bastion_lc" {
  name                        = "bastion_lc"
  image_id                    = data.aws_ami.amazon_latest.id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "edu"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bhasg" {
  name                 = "bhasg"
  launch_configuration = aws_launch_configuration.bastion_lc.name
  vpc_zone_identifier  = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  min_size             = 1
  max_size             = 1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "webserver_lc" {
  name            = "webserver_lc"
  image_id        = data.aws_ami.amazon_latest.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web_server_sg.id]
  user_data       = file("install_apache.sh")
  key_name        = "edu"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wsasg" {
  name                 = "wsasg"
  launch_configuration = aws_launch_configuration.webserver_lc.name
  vpc_zone_identifier  = [aws_subnet.app_private_subnet_a.id, aws_subnet.app_private_subnet_b.id]
  min_size             = 1
  max_size             = 4
  desired_capacity     = 2
  default_cooldown     = 300
  health_check_type = "ELB"
  load_balancers = [aws_elb.CLB.id]

  lifecycle {
    create_before_destroy = true
  }
}
