
variable "aws_account_id" {
  description = "The AWS account identifier of the project"
  type = string
  default = "1234567891234"
}

# needs to be a var to reference from local block
variable "prefix" {
  description = "The resource prefix"
  type = string
  default = "alf-dev-eks"
}

# needs to be a var to reference from local block
variable "environment" {
  description = "The environment"
  type = string

  # refers to folder-structure
  default = "env1" 
}


locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  aws_region =      "eu-central-1"

  environment_path = "environments/${var.environment}/"

  # make also adressable via "var."
  prefix = "${var.prefix}"
  environment = "${var.environment}"     

  name            = "${var.prefix}-auth0-eks"
  cluster_version = "1.28"
  instance_types  = ["t2.small"] # can be multiple, comma separated

  vpc_cidr = "10.0.0.0/16"

  aws_account_id = data.aws_caller_identity.current.account_id
  
  # the role, which will be granted access on AWS console > EKS
  # to avoid the error "Your current IAM principal doesnt have access to Kubernetes objects on this cluster"
  aws_federation_iam_rolename="AWSReservedSSO_AdministratorAccess-unrestricted_58c9bbf239970a34"

  tags = {
    Terraform = "true"
    Environment = "dev"
    Blueprint  = local.name
    Purpose = "experiment"
  }
}


