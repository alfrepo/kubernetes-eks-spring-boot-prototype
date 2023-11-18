
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
  instance_types  = ["t2.large"] # can be multiple, comma separated

  vpc_cidr = "10.0.0.0/16"


  tags = {
    Terraform = "true"
    Environment = "dev"
    Blueprint  = local.name
    Purpose = "experiment"
  }
}


