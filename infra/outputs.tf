# VPC Outputs
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the VPC"
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "CIDR block of the VPC"
}

output "public_subnet_1_id" {
  value       = aws_subnet.public_1.id
  description = "ID of public subnet 1"
}

output "public_subnet_2_id" {
  value       = aws_subnet.public_2.id
  description = "ID of public subnet 2"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "ID of the Internet Gateway"
}

output "web_security_group_id" {
  value       = aws_security_group.web.id
  description = "ID of the web security group"
}

output "database_security_group_id" {
  value       = aws_security_group.database.id
  description = "ID of the database security group"
}

# S3 Outputs
output "bucket_name" {
  value       = aws_s3_bucket.fastapi_bucket.bucket
  description = "Nombre del bucket S3 creado para la app FastAPI"
}

