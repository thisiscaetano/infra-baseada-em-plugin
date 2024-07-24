output "project_id" {
  description = "ID do projeto GCP"
  value       = var.project_id
}

output "cluster_name" {
  description = "Nome do cluster"
  value       = module.gke.name
}
output "region" {
  description = "Região do cluster"
  value       = local.region
}