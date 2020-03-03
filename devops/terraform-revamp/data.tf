data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["679593333241"] # centos.org

  filter {
    name = "name"
    value = [
      "CentOS Linux 7 x86_64 HVM EBS*"
    ]
  }
}