# Resource: aws_iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

# Create IAM role for EKS Node Group
resource "aws_iam_role" "nodes_general" {
  # The name of the role
  name = "eks-node-group-general"

  # The policy that grants an entity permission to assume the role.
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Resource: aws_iam_role_policy_attachment
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  # The ARN of the policy you want to apply.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  # The ARN of the policy you want to apply.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  # The ARN of the policy you want to apply.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  # The role the policy should be applied to
  role = aws_iam_role.nodes_general.name
}

# Resource: aws_eks_node_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group

resource "aws_eks_node_group" "nodes_general" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "nodes-general"
  node_role_arn = aws_iam_role.nodes_general.arn

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  # Configuration block with scaling settings
  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 1
  }

  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 20
  force_update_version = false
  instance_types = ["t3.small"]

  labels = {
    role = "nodes-general"
  }

  # Kubernetes version
  version = "1.22"

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}