resource "aws_eks_cluster" "demo" {
  name     = var.eks-name
  role_arn = aws_iam_role.demo-eks.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.demo-eks.id]
    subnet_ids              = [aws_subnet.public-1.id, aws_subnet.public-2.id, aws_subnet.public-3.id, aws_subnet.private-1.id, aws_subnet.private-2.id, aws_subnet.private-3.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-eks-AmazonEKSServicePolicy,
  ]
}

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

locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo.endpoint}' --b64-cluster-ca '${aws_eks_cluster.demo.certificate_authority[0].data}' '${var.eks-name}'
USERDATA
}

resource "aws_launch_configuration" "demo" {
  iam_instance_profile = aws_iam_instance_profile.eks-node.name
  image_id             = data.aws_ami.eks-worker.id
  instance_type        = var.eks-worker-instance-type
  name_prefix          = "tf-"
  security_groups      = [aws_security_group.demo-eks.id]
  user_data_base64     = base64encode(local.eks-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  name                 = var.eks-name
  launch_configuration = aws_launch_configuration.demo.id

  desired_capacity    = 3
  max_size            = 5
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.private-1.id, aws_subnet.private-2.id, aws_subnet.private-3.id]

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
