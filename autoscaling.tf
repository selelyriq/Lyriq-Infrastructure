resource "aws_launch_template" "Webserver" {
  name = "Webserver"
  image_id = "ami-06b08f0bf3eaf34a9"
  instance_type = "t2.micro"
}

resource "aws_placement_group" "Webserver" {
  name     = "Webserver"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "webserver" {
  name                      = local.setup_name 
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  placement_group           = aws_placement_group.Webserver.id
  launch_template {
    id      = aws_launch_template.Webserver.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [aws_subnet.Public_subnet.id, aws_subnet.Private_subnet.id]

#   instance_maintenance_policy {
#     min_healthy_percentage = 90
#     max_healthy_percentage = 120
#   }

  initial_lifecycle_hook {
    name                 = "Webserver"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = jsonencode({
      foo = "bar"
    })

    notification_target_arn = aws_sqs_queue.scaling_queue.arn
    role_arn                = aws_iam_role.scaling.arn
  }

  tag {
    key                 = "Name"
    value               = "Webserver"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "Webserver"
    propagate_at_launch = false
  }
}