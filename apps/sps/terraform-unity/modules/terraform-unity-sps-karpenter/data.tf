data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

data "aws_iam_role" "cluster_iam_role" {
  name = "${local.cluster_name}-eks-node-role"
}
