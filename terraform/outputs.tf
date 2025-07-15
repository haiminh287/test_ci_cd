output "cluster_name" {
  description = "Tên cụm EKS"
  value       = module.eks.cluster_name
}


output "cluster_endpoint" {
  description = "API endpoint của cụm"
  value       = module.eks.cluster_endpoint
}
