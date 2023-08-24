### User Profile Arns
output "sagemaker_user_profile_resource_arns" { value = values(aws_sagemaker_user_profile.example)[*].arn }