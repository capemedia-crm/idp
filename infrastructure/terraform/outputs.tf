output "role_arn" {
  value = aws_iam_role.this.arn
}

output "service_name" {
  value = var.service_name
}

output "namespace" {
  value = var.namespace
}

output "ssm_prefix" {
  value = local.ssm_prefix
}
