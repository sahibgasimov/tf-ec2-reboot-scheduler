

## AWS Instance Reboot Scheduler using Terraform

This Terraform code sets up an automated EC2 reboot schedule for specified AWS EC2 instances using Amazon EventBridge Scheduler. It also creates the necessary IAM roles and policies to allow the scheduler to interact with the EC2 instances.

Note: There is one limitation: You can only add up to five targets. If you need more then you have to use System Manager.

### Features:

- Define a cron-based schedule for rebooting EC2 instances.
- Use flexible time windows with Amazon EventBridge Scheduler.
- Define IAM roles and policies for secure execution.


### Prerequisites:

Terraform >= v0.15.1
AWS account

### Usage:

1. Clone the repository:
    ```
    git clone https://github.com/sahibgasimov/tf-ec2-reboot-scheduler.git
    cd tf-ec2-reboot-scheduler
    ```
2. Initialize Terraform:
    ```hcl
    terraform init
    ``````
3. Configure your variables:

   Specify the required variables in terraform.tfstate file:

    ```hcl
    region = "us-east-2"
    instance_ids = ["i-0xxxxx", "i-1yyyyy"]
    account_id = "your-aws-account-id"
    aws_cloudwatch_event_scheduler_name = "your-scheduler-name"
    schedule_expression = "your-cron-expression"  # E.g., "cron(0 8 ? * MON-FRI *)"
    ```
4. Apply the Terraform code:
    ```
    terraform plan
    terraform apply -var-file terraform.tfvars

    ```
5. Destroy resources (if needed):

    ```
    terraform destroy
    ```

Variables:
- region: AWS region to deploy the resources. Default is us-east-2.
- instance_ids: A list of EC2 instance IDs that you want to manage with the scheduler.
- account_id: Your AWS account ID.
- aws_cloudwatch_event_scheduler_name: A unique name for your EventBridge scheduler.
- schedule_expression: The cron expression representing your desired schedule.

