#---------------------------------------------------------------
# EKS cluster, worker nodes, security groups, IAM roles, K8s add-ons, etc.
#---------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets

  # EKS Addons
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }
  eks_managed_node_group_defaults = {
    # Needed by the aws-ebs-csi-driver
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
  }
  eks_managed_node_groups = {
    initial = {
      instance_types = local.instance_types
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      subnet_ids     = module.vpc.private_subnets
    }
  }

  tags = local.tags
}

module "eks_blueprints_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id        = module.eks.cluster_name
  eks_cluster_endpoint  = module.eks.cluster_endpoint
  eks_cluster_version   = module.eks.cluster_version
  eks_oidc_provider     = module.eks.oidc_provider
  eks_oidc_provider_arn = module.eks.oidc_provider_arn

  # K8S Add-ons
  enable_aws_load_balancer_controller = true
  enable_metrics_server               = true
  enable_aws_cloudwatch_metrics       = false

  tags = local.tags
}

# To update local kubeconfig with new cluster details
resource "null_resource" "kubeconfig" {
  depends_on = [module.eks_blueprints_addons]
  provisioner "local-exec" {
    command = "aws eks --region ${local.aws_region}  update-kubeconfig --name $AWS_CLUSTER_NAME"
    environment = {
      AWS_CLUSTER_NAME = local.name
    }
  }
}



# Define a null_resource to trigger the script after the EKS cluster is created
resource "null_resource" "enable_federated_role_for_eksconsole_script" {
  # This resource depends on the creation of the EKS cluster
  depends_on = [module.eks.cluster_id]

  triggers = {
    eks_cluster_id = module.eks.cluster_id
  }

  # Use the local-exec provisioner to execute your shell script
  provisioner "local-exec" {
    command = "bash enableRoleForEksIdempotent.sh"
    
    # You can also use environment variables or pass data to the script
    environment = {
      rolename = local.aws_federation_iam_rolename
      accountId = local.aws_account_id
      clustername = module.eks.cluster_name
    }
  }
}
