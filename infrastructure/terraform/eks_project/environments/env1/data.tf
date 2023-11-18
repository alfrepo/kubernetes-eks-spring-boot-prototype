#
# Gets information from environment
#  e.g. permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/gitlab-runner/horizonboundary"
#
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}