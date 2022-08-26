output "vpc_id" {
  description = "This is the VPC id referencing vpc.tf"
  value       = aws_vpc.eks_vpc.id
  sensitive = false
}