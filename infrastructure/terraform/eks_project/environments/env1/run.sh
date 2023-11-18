#!/bin/bash
set -eo pipefail
 
if [[ ! -d ".terraform" ]]
then
  terraform init
fi
 
terraform validate
terraform plan -out="PLAN.TERRAFORM"
 
terraform apply "PLAN.TERRAFORM"