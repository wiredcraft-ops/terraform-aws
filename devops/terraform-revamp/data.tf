data "aws_ami" "centos" {
  filter {
    name = "product-code"
    values = [
      "aw0evgkw8e5c1q413zgy5pjce" # need to subscribe first: https://aws.amazon.com/marketplace/pp?sku=aw0evgkw8e5c1q413zgy5pjce
    ]
  }

  most_recent = true
  owners      = ["679593333241"] # aws-marketplace
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.demo.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
}
