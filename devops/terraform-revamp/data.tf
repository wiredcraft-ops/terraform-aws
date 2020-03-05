data "aws_ami" "centos" {
  most_recent = true

  owners = ["679593333241"] # aws-marketplace

  filter {
    name = "product-code"
    values = [
      "aw0evgkw8e5c1q413zgy5pjce" # need to subscribe first: https://aws.amazon.com/marketplace/pp?sku=aw0evgkw8e5c1q413zgy5pjce
    ]
  }
}