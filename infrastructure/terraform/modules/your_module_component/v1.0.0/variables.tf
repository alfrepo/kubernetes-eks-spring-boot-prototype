variable "aws_region" {
  description = "The AWS region to deploy the resources into"
  type = string
}

variable "aws_account_id" {
  description = "The AWS account identifier of the project"
  type = string
}

variable "prefix" {
  description = "The resource prefix"
  type = string
  default = "alf-dev-terraskelett"
}

locals {
  aws_iam_role_name = "${var.prefix}-iam_codebuild_role"
}
