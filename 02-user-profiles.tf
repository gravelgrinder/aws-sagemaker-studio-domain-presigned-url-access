###############################################################################
### SageMaker User Profile Role
###############################################################################
resource "aws_sagemaker_user_profile" "example" {
  for_each          = local.smsUsers
  domain_id         = aws_sagemaker_domain.example.id
  user_profile_name = join("-", ["sms-up", replace(each.key, "/[+.@]/", "-")])
  user_settings {
    execution_role = aws_iam_role.sm_execution_role.arn
  }

  tags = {
    userName       = each.key
    employeeNumber = each.value
  }
}
###############################################################################


###############################################################################
### SageMaker User Profile App (Jupyter)
###############################################################################
resource "aws_sagemaker_app" "example" {
  for_each          = local.smsUsers
  domain_id         = aws_sagemaker_domain.example.id
  user_profile_name = aws_sagemaker_user_profile.example[each.key].user_profile_name
  app_name          = "default"
  app_type          = "JupyterServer"
}
###############################################################################
