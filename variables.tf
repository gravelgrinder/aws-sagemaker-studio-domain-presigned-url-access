variable "sagemaker_studio_domain_vpc_id" {
  type    = string
  default = "vpc-00b09e53c6e62a994"
}

variable "sagemaker_studio_domain_subnet_ids" {
  type    = list(string)
  #Private A,B and C Subnets
  default = ["subnet-069a69e50bd1ebb23", "subnet-0871b35cbe9d0c1cf", "subnet-045bd90a8091ea930"]
}

locals {
  smsUsers = {
    "lwdvin+developer" = "a01234"
    "lwdvin"           = "a00001"
    "jon.doe"          = "a00002"
  }
}
