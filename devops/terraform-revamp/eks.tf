resource "aws_eks_cluster" "demo" {
  name     = var.eks-name
  role_arn = aws_iam_role.eks.arn

  version = "1.15"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = var.bastion-whitelist
    security_group_ids      = [aws_security_group.demo-eks.id, aws_security_group.eks-node.id]
    subnet_ids              = concat([for subnet in aws_subnet.private : subnet.id], [for subnet in aws_subnet.public : subnet.id])
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy,
  ]
}

#
# EKS managed node group
#

# resource "aws_eks_node_group" "demo" {
#   cluster_name    = aws_eks_cluster.demo.name
#   node_group_name = "demo"
#   node_role_arn   = aws_iam_role.demo-eks-node.arn
#   subnet_ids      = [aws_subnet.private.id]

#   scaling_config {
#     desired_size = 3
#     max_size     = 5
#     min_size     = 2
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.demo-eks-node-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.demo-eks-node-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.demo-eks-node-AmazonEC2ContainerRegistryReadOnly,
#   ]

#   remote_access {
#     ec2_ssh_key = aws_key_pair.qingfeng.key_name
#     # allow ssh from servers inside VPC
#     source_security_group_ids = [aws_vpc.demo.default_security_group_id]
#   }
# }

#
# Self created autoscaling group
#

locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo.endpoint}' --b64-cluster-ca '${aws_eks_cluster.demo.certificate_authority[0].data}' '${var.eks-name}'
USERDATA
}

resource "aws_launch_configuration" "demo" {
  name_prefix = "tf-"

  image_id             = data.aws_ami.eks-worker.id
  instance_type        = var.eks-worker-instance-type
  iam_instance_profile = aws_iam_instance_profile.eks-node.name

  key_name = aws_key_pair.qingfeng.key_name

  security_groups = [aws_security_group.demo-eks.id, aws_security_group.eks-node.id]

  user_data_base64 = base64encode(local.eks-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  count = var.subnet-count

  name_prefix = "tf-"

  launch_configuration = aws_launch_configuration.demo.id

  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  vpc_zone_identifier = [aws_subnet.private[count.index].id]

  target_group_arns = [aws_lb_target_group.demo.arn]

  tag {
    key                 = "Name"
    value               = var.eks-name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.eks-name}"
    value               = "owned"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
