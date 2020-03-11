variable "name" {
  default = "tf-demo"
}

variable "region" {
  default = "us-west-2"
}

variable "vpc-cidr" {
  default = "172.16.0.0/16"
}

variable "public-subnet-1-cidr" {
  default = "172.16.1.0/20"
}

variable "public-subnet-2-cidr" {
  default = "172.16.16.0/20"
}

variable "public-subnet-3-cidr" {
  default = "172.16.32.0/20"
}

variable "private-subnet-1-cidr" {
  default = "172.16.112.0/20"
}

variable "private-subnet-2-cidr" {
  default = "172.16.128.0/20"
}

variable "private-subnet-3-cidr" {
  default = "172.16.144.0/20"
}

variable "az-1" {
  default = "usw2-az1"
}

variable "az-2" {
  default = "usw2-az2"
}

variable "az-3" {
  default = "usw2-az3"
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

# eks
variable "eks-name" {
  default = "tf-demo-eks"
}

variable "eks-worker-instance-type" {
  default = "t3.small"
}