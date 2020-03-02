 # This data source is included for ease of sample architecture deployment
 # and can be swapped out as necessary.
 data "aws_availability_zones" "available" {
 }

 data "aws_ami" "eks-worker" {
   filter {
     name   = "name"
     values = ["amazon-eks-node-${aws_eks_cluster.demo.version}-v*"]
   }

   most_recent = true
   owners      = ["602401143452"] # Amazon EKS AMI Account ID
 }