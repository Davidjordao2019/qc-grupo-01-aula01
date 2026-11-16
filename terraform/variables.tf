variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "quantum-commerce"
}

variable "environment" {
  description = "Ambiente de implantação"
  type        = string
  default     = "prod"
}

# Variáveis AWS (Ambiente Ativo)
variable "aws_region" {
  description = "Região principal na AWS"
  type        = string
  default     = "us-east-1"
}

variable "aws_azs" {
  description = "3 Zonas de Disponibilidade para resiliência celular"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Variáveis GCP (Ambiente Stand-by)
variable "gcp_project_id" {
  description = "ID do projeto na Google Cloud Platform"
  type        = string
  default     = "quantum-commerce-dr"
}

variable "gcp_region" {
  description = "Região de Stand-by na GCP"
  type        = string
  default     = "us-central1"
}

variable "db_master_password" {
  description = "Senha mestre dos bancos relacionais/vetoriais"
  type        = string
  sensitive   = true
}