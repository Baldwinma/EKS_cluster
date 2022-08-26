# Resource: aws_eip
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

resource "aws_eip" "nat1" {
  # Use depends_on as EIP might need IGW to provision first 
  depends_on = [aws_internet_gateway.eks_vpc]
}

resource "aws_eip" "nat2" {
  # Use depends_on as EIP might need IGW to provision first 
  depends_on = [aws_internet_gateway.eks_vpc]
}