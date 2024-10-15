resource "aws_launch_template" "Webserver" {
  name = "Webserver"
  image_id = "ami-06b08f0bf3eaf34a9"
  instance_type = "t2.micro"
}

resource "aws_placement_group" "Webserver" {
  name     = "Webserver"
  strategy = "cluster"
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.webserver.name
}

resource "aws_autoscaling_group" "webserver" {
  name                      = "Webserver"
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
  vpc_zone_identifier       = [var.public_subnet_id, var.private_subnet_id]

  # initial_lifecycle_hook {
  #   name                 = "Webserver"
  #   default_result       = "CONTINUE"
  #   heartbeat_timeout    = 2000
  #   lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

  #   notification_metadata = jsonencode({
  #     foo = "bar"
  #   })

  #   notification_target_arn = var.scaling_queue_arn
  #   role_arn                = var.iam_role_arn
  # }

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

###Scaling IAM

resource "aws_iam_role" "scaling" {
  name = "autoscaling_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
      }
    ]
  })
}

output "scaling_role_arn" {
  value = aws_iam_role.scaling.arn
}

output "scaling_role_name" {
  value = aws_iam_role.scaling.name
}

resource "aws_iam_role_policy_attachment" "scaling" {
  role       = aws_iam_role.scaling.name
  policy_arn = aws_iam_policy.scaling.arn
}

resource "aws_iam_policy" "scaling" {
  name   = "tf-iam-policy-scaling-12345"
  policy = data.aws_iam_policy_document.scaling.json
}

data "aws_iam_policy_document" "scaling" {
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:CompleteLifecycleAction",
    ]

    resources = ["*"]
  }
}