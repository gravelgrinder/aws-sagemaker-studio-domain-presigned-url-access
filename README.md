# aws-sagemaker-studio-domain-presigned-url-access
Repo that describes how to connect to SageMaker Studio using a Domain Pre Signed URL.  Within this demo we will be creating the Sagemaker Domain, User Profiles and Jupiter Apps for each defined user.  Then we will discuss howe to implemented restricted access via Attribute Based Access Control (ABAC) where we restrict access to the Sagemaker Notebooks based on employeeNumber.  We can easly add new Sagemaker Studio User Profiles by adding a new user+employeeNumber to the local variable smsUsers (which can be found in the `variables.tf` file).

## Architecture
![alt text](https://github.com/gravelgrinder/aws-sagemaker-studio-domain-presigned-url-access/blob/main/architecture_diagram.png?raw=true)

## Setup Steps
1. Run the following to Initialize the Terraform environment.

```
terraform init
```

2. Provision the resources in the Terraform scripts.  This will create an Amazon Sagemaker Domain, user profiles and apps based on the local values in the smsUsers variable.

```
terraform apply
```

3. The terraform scripts will provision Amazon Sagemaker user profiles with tag values for "userName" and "employeeNumber".  Lets confirm the user profiles that were just created are tagged with the correct values for our users.
```
aws sagemaker list-tags --resource-arn <sagemaker_user_profile_resource_arns Output Value>
```
Here is an example of running the command.
```
lwdvin@a483e7078b3f aws-sagemaker-studio-domain-presigned-url-access % aws sagemaker list-tags --resource-arn arn:aws:sagemaker:us-east-1:*********617:user-profile/d-*********gka/sms-up-lwdvin
{
    "Tags": [
        {
            "Key": "userName",
            "Value": "lwdvin"
        },
        {
            "Key": "employeeNumber",
            "Value": "a00001"
        }
    ]
}
lwdvin@a483e7078b3f aws-sagemaker-studio-domain-presigned-url-access % 
lwdvin@a483e7078b3f aws-sagemaker-studio-domain-presigned-url-access % 
lwdvin@a483e7078b3f aws-sagemaker-studio-domain-presigned-url-access % 
lwdvin@a483e7078b3f aws-sagemaker-studio-domain-presigned-url-access % aws sagemaker list-tags --resource-arn arn:aws:sagemaker:us-east-1:*********617:user-profile/d-*********gka/sms-up-lwdvin-developer
{
    "Tags": [
        {
            "Key": "userName",
            "Value": "lwdvin+developer"
        },
        {
            "Key": "employeeNumber",
            "Value": "a01234"
        }
    ]
}
```

4. Grant permissions to the user. Now you can grant the user the ability to Create a Presigned Domain URL for the corresponding user profile.  We do this by leveraging Attribute Basesd Access Control and placing a conditional check within our IAM policy to verify the key value on the resouce matches the key value for the Federated Principal user.  Here is an example DENY policy that will restrict users from launching notebooks that are not tagged approprtaly with their employeeNumber.  With this approach we could use username if that is preferred.
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Deny",
			"Action": [
				"sagemaker:CreatePresignedNotebookInstanceUrl",
				"sagemaker:CreatePresignedDomainUrl"
			],
			"Resource": "*",
			"Condition": {
				"StringNotEquals": {
					"sagemaker:ResourceTag/employeeNumber": "${aws:PrincipalTag/employeeNumber}"
				}
			}
		}
	]
}
```

## Clean up Resources
1. To delete the resources created from the terraform script run the following.
```
terraform destroy
```

## Helpful Resources
* [AWS ML Blog - Configuring Amazon SageMaker Studio for teams and groups with complete resource isolation](https://aws.amazon.com/blogs/machine-learning/configuring-amazon-sagemaker-studio-for-teams-and-groups-with-complete-resource-isolation/)
* [AWS ML Blog - Dive deep into Amazon SageMaker Studio Notebooks architecture](https://aws.amazon.com/blogs/machine-learning/dive-deep-into-amazon-sagemaker-studio-notebook-architecture/)
* [AWS ML Blog - Securing Amazon SageMaker Studio connectivity using a private VPC](https://aws.amazon.com/blogs/machine-learning/securing-amazon-sagemaker-studio-connectivity-using-a-private-vpc/)
* [What is ABAC for AWS?](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction_attribute-based-access-control.html)
* [About SAML 2.0-based federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html)
* [Amazon Sagemaker: Service Authorization Reference for CreatePresignedDomainUrl](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonsagemaker.html#amazonsagemaker-CreatePresignedDomainUrl)
* [Really Helpful for CloudTrail logging per UserProfile. Make sure to enable if using the same execution role between User Profiles!](https://docs.aws.amazon.com/sagemaker/latest/dg/monitor-user-access.html)
* [SAML Troubleshooting 403 error](https://docs.aws.amazon.com/IAM/latest/UserGuide/troubleshoot_saml.html#troubleshoot_saml_missing-role)
* [Permissions required to add session tags](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_session-tags.html#id_session-tags_permissions-required)


## Questions & Comments
If you have any questions or comments on the demo please reach out to me [Devin Lewis - AWS Solutions Architect](mailto:lwdvin@amazon.com?subject=AWS%2FTerraform%20Sagemaker%20Studio%20Domain%20and%20User%20Profile%20Creation%20Demo%20%28aws-sagemaker-studio-domain-presigned-url-access%29)

Of if you would like to provide personal feedback to me please click [Here](https://feedback.aws.amazon.com/?ea=lwdvin&fn=Devin&ln=Lewis)
