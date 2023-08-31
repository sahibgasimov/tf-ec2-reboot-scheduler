########VARIABLES#####

variable "region" {
  type        = string
  description = "Region to deploy resources"
  default = "us-east-2"
}

variable "instance_ids" {
  type        = list(string)
  description = "List of EC2 instance IDs to manage"
}

variable "account_id" {
  type        = string
  description = "instance_id to deploy resources"
}

variable "aws_cloudwatch_event_scheduler_name" {
  type        = string
  description = "instance_id to deploy resources"
}

variable "schedule_expression" {
  type        = string
  description = "instance_id to deploy resources"
}