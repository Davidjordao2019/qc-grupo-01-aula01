# ==============================================================================
# REDE BASE (3 Zonas de Disponibilidade)
# ==============================================================================
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc-active"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.aws_azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone = var.aws_azs[count.index]

  tags = {
    Name = "${var.project_name}-private-${var.aws_azs[count.index]}"
  }
}

# ==============================================================================
# CAMADA 1 & 5: STORAGE (S3) E BORDA/CDN (CLOUDFRONT)
# ==============================================================================
resource "aws_s3_bucket" "catalog_assets" {
  bucket = "${var.project_name}-catalog-5m-skus-${var.environment}"
}

resource "aws_s3_bucket" "analytics_datalake" {
  bucket = "${var.project_name}-olap-datalake-${var.environment}"
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.project_name}-s3-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  comment             = "CDN Global Quantum Commerce (12 países)"
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.catalog_assets.bucket_regional_domain_name
    origin_id                = "S3-Catalog"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-Catalog"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# ==============================================================================
# CAMADA 2: COMPUTAÇÃO & MICROSSERVIÇOS (EKS - ISTIO / HPA / KEDA)
# ==============================================================================
resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "active_cluster" {
  name     = "${var.project_name}-eks-active"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.private[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# ==============================================================================
# CAMADA 3: MENSAGERIA E EVENTOS (SNS + SQS PARA KEDA)
# ==============================================================================
resource "aws_sns_topic" "order_events" {
  name = "${var.project_name}-order-events"
}

resource "aws_sqs_queue" "sku_indexing_queue" {
  name                       = "${var.project_name}-sku-vector-indexing"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
}

resource "aws_sns_topic_subscription" "order_to_sqs" {
  topic_arn = aws_sns_topic.order_events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sku_indexing_queue.arn
}

# ==============================================================================
# CAMADA 4 & 5: BANCO RELACIONAL + VETORIAL (AURORA POSTGRESQL / PGVECTOR)
# ==============================================================================
resource "aws_db_subnet_group" "aurora" {
  name       = "${var.project_name}-aurora-subnets"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_rds_cluster" "aurora_pgvector" {
  cluster_identifier     = "${var.project_name}-aurora-pg"
  engine                 = "aurora-postgresql"
  engine_version         = "16.1"
  database_name          = "quantum_commerce"
  master_username        = "qc_admin"
  master_password        = var.db_master_password
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  skip_final_snapshot    = true
  storage_encrypted      = true
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 2
  identifier         = "${var.project_name}-aurora-node-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_pgvector.id
  instance_class     = "db.r6g.large"
  engine             = aws_rds_cluster.aurora_pgvector.engine
  engine_version     = aws_rds_cluster.aurora_pgvector.engine_version
}

# ==============================================================================
# CAMADA 5: BANCO NOSQL (DYNAMODB - SESSÕES E HISTÓRICO DE CHAT IA)
# ==============================================================================
resource "aws_dynamodb_table" "chat_sessions" {
  name         = "${var.project_name}-ai-chat-sessions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "session_id"
  range_key    = "timestamp"

  attribute {
    name = "session_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }
}

# ==============================================================================
# CAMADA 6: OBSERVABILIDADE TRANSVERSAL (CLOUDWATCH)
# ==============================================================================
resource "aws_cloudwatch_log_group" "platform_logs" {
  name              = "/${var.project_name}/${var.environment}/microservices"
  retention_in_days = 30
}