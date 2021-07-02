resource "aws_launch_configuration" "bastion_lc" {
  name                        = "bastion_lc"
  image_id                    = data.aws_ami.amazon_latest.id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "ppln"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion_asg" {
  name                 = "bastion_asg"
  launch_configuration = aws_launch_configuration.bastion_lc.name
  vpc_zone_identifier  = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  min_size             = 1
  max_size             = 1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "game_lc" {
  name                        = "game_lc"
  image_id                    = data.aws_ami.amazon_latest.id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = true
  key_name                    = "ppln"
  user_data                   = file("install_apache+game.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "game_asg" {
  name                 = "game_asg"
  launch_configuration = aws_launch_configuration.game_lc.name
  vpc_zone_identifier  = [aws_subnet.webserver_subnet_a.id, aws_subnet.webserver_subnet_b.id]
  min_size             = 1
  max_size             = 1
  target_group_arns    = [aws_lb_target_group.game_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "webserver_lc" {
  name            = "webserver_lc"
  image_id        = data.aws_ami.amazon_latest.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web_server_sg.id]
  associate_public_ip_address = true
  key_name  = "ppln"
  user_data = file("install_apache.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver_asg" {
  name                 = "webserver_asg"
  launch_configuration = aws_launch_configuration.webserver_lc.name
  vpc_zone_identifier  = [aws_subnet.webserver_subnet_a.id, aws_subnet.webserver_subnet_b.id]
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  default_cooldown     = 300
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.webserver_tg.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "webserver_policy_up" {
  name                   = "webserver_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
}

resource "aws_cloudwatch_metric_alarm" "webserver_cpu_alarm_up" {
  alarm_name          = "webserver_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.webserver_policy_up.arn]
}

resource "aws_autoscaling_policy" "webserver_policy_down" {
  name                   = "webserver_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.name
}

resource "aws_cloudwatch_metric_alarm" "webserver_cpu_alarm_down" {
  alarm_name          = "webserver_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webserver_asg.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.webserver_policy_down.arn]
}