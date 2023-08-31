terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.15"
    }
  }
}

provider "aws" {
  region = var.region
}


# This section creates cron schedules using Amazon EventBridge Scheduler, as well as the required IAM roles to interact with EC2
resource "aws_scheduler_schedule" "ec2-start-schedule" {
  count = length(var.instance_ids)

  name = "ec2-scheduler-reboot-${var.aws_cloudwatch_event_scheduler_name}-${var.instance_ids[count.index]}"
  
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression # Scheduled startInstances at 8am EST Mon-Fri
  schedule_expression_timezone = "US/Eastern" # Default is UTC
  description = "Reboot EC2 instances"

  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:rebootInstances"
    role_arn = aws_iam_role.scheduler-ec2-role.arn
  
    input = jsonencode({
      "InstanceIds": [
        var.instance_ids[count.index]
      ]
    })
  }
}


resource "aws_iam_policy" "scheduler_ec2_policy" {
  name = "ec2-reboot-${var.aws_cloudwatch_event_scheduler_name}"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = ["ec2:RebootInstances"],
        Effect   = "Allow",
        Resource = [for id in var.instance_ids : "arn:aws:ec2:${var.region}:${var.account_id}:instance/${id}"]
      }
    ]
  })
}


resource "aws_iam_role" "scheduler-ec2-role" {
  name = "ec2-reboot-${var.aws_cloudwatch_event_scheduler_name}"
  managed_policy_arns = [aws_iam_policy.scheduler_ec2_policy.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      }
    ]
  })
}

