output "s3_bucket_id" {
  value       = aws_s3_bucket.bucket.id
  description = "Bucket Name (aka ID)"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "Bucket ARN"
}

output "s3_bucket_region" {
  value       = aws_s3_bucket.bucket.region
  description = "AWS Region of Bucket"
}

output "s3_bucket_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_domain_name
  description = "FQDN of Bucket"
}

output "s3_bucket_regional_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
  description = "Regional FQDN_ of Bucket"
}
