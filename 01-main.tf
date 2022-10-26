provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


###############################################################################
### SageMaker Execution Role
###############################################################################
data "template_file" "sm_execution_policy" {
  template = "${file("iam/sm_execution_policy.json")}"

  vars = {}
}

data "template_file" "assume_role_policy" {
  template = "${file("iam/assume_role_policy.json")}"

  vars = {}
}

resource "aws_iam_policy" "sm_execution_policy" {
  name        = "tf_sm_execution_policy"
  description = "IAM Policy to allow SageMaker the necessary permissions to access AWS Services and Resources."
  policy      = "${data.template_file.sm_execution_policy.rendered}"
}

resource "aws_iam_role" "sm_execution_role" {
  name                = "tf_sagemaker_execution_role"
  assume_role_policy  = "${data.template_file.assume_role_policy.rendered}"
  managed_policy_arns = [aws_iam_policy.sm_execution_policy.arn, "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess", "arn:aws:iam::aws:policy/AmazonSageMakerCanvasFullAccess"]
}
###############################################################################



###############################################################################
### Amazon SageMaker Domain
###############################################################################
resource "aws_sagemaker_domain" "example" {
  domain_name             = "tf-djl-sm-domain"
  auth_mode               = "IAM"
  vpc_id                  = var.sagemaker_studio_domain_vpc_id
  subnet_ids              = var.sagemaker_studio_domain_subnet_ids
  app_network_access_type = "VpcOnly"

  default_user_settings {
    execution_role = aws_iam_role.sm_execution_role.arn
  }
}
###############################################################################