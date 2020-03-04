variable "region" {
  default = "us-west-2"
}

variable "vpc-cidr" {
  default = "172.16.0.0/16"
}

variable "public-subnet-cidr" {
  default = "172.16.1.0/24"
}

variable "private-subnet-cidr" {
  default = "172.16.10.0/24"
}

variable "wcl-ips" {
  type    = list(string)
  default = ["222.66.90.82/32", "103.220.77.16/32"]
}