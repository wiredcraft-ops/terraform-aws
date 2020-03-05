resource "aws_eks_cluster" "demo" {
  name     = var.eks-name
  role_arn = aws_iam_role.demo-eks.arn

  vpc_config {
    security_group_ids = [aws_security_group.demo-eks.id]
    subnet_ids         = [aws_subnet.public.id, aws_subnet.private.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-eks-AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_node_group" "demo" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "demo"
  node_role_arn   = aws_iam_role.demo-eks-node.arn
  subnet_ids      = [aws_subnet.private.id]

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo-eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo-eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]

  remote_access {
    ec2_ssh_key = aws_key_pair.qingfeng.key_name
    # allow ssh from servers inside VPC
    source_security_group_ids = [aws_vpc.demo.default_security_group_id]
  }
}
