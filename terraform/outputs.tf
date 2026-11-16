output "aws_cloudfront_domain" {
  description = "Endpoint global da CDN (Camada 1 - Ativo)"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "aws_eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS Ativo (Camada 2)"
  value       = aws_eks_cluster.active_cluster.endpoint
}

output "aws_aurora_writer_endpoint" {
  description = "Endpoint de escrita do Aurora PostgreSQL / Vetores (Camadas 4 e 5)"
  value       = aws_rds_cluster.aurora_pgvector.endpoint
}

output "aws_sqs_indexing_url" {
  description = "URL da fila SQS monitorada pelo KEDA (Camada 3)"
  value       = aws_sqs_queue.sku_indexing_queue.id
}

output "gcp_gke_standby_endpoint" {
  description = "Endpoint do cluster GKE Stand-by na GCP (Camada 2 DR)"
  value       = google_container_cluster.gke_standby.endpoint
}