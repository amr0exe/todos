output "acm_certificate_arn" {
  value       = aws_acm_certificate_validation.valid.certificate_arn
  description = "The ARN of validated ACM certificate"
}
