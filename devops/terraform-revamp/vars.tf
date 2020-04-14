variable "name" {
  default = "tf-demo"
}

variable "region" {
  default = "us-west-2"
}

variable "vpc-cidr" {
  default = "172.16.0.0/16"
}

variable "subnet-count" {
  default = 3
}

variable "az-names" {
  type    = list(string)
  default = ["usw2-az1", "usw2-az2", "usw2-az3"]
}

variable "bastion-whitelist" {
  type    = list(string)
  default = ["222.66.90.82/32", "103.220.77.16/32"]
}

# bastion
variable "bastion-instance-type" {
  default = "t3.micro"
}

# database
variable "database-instance-type" {
  default = "t3.micro"
}

variable "database-count" {
  default = 1 # must less than subnet count
}

# eks
variable "eks-name" {
  default = "tf-demo-eks"
}

variable "eks-worker-instance-type" {
  default = "t3.small"
}