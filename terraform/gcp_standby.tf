# ==============================================================================
# CAMADA 1 & 5: CLOUD STORAGE (CATÁLOGO E ANALÍTICO STAND-BY)
# ==============================================================================
resource "google_storage_bucket" "catalog_standby" {
  name                        = "${var.project_name}-catalog-dr-${var.environment}"
  location                    = "US"
  uniform_bucket_level_access = true
}

# ==============================================================================
# CAMADA 2: COMPUTAÇÃO STAND-BY (GKE REGIONAL EM 3 ZONAS)
# ==============================================================================
resource "google_container_cluster" "gke_standby" {
  name     = "${var.project_name}-gke-standby"
  location = var.gcp_region

  # Cluster Autopilot ou Regional com 3 zonas para equivalência ao EKS
  enable_autopilot = true
}

# ==============================================================================
# CAMADA 3: MENSAGERIA ASSÍNCRONA (PUB/SUB)
# ==============================================================================
resource "google_pubsub_topic" "events_standby" {
  name = "${var.project_name}-events-dr"
}

resource "google_pubsub_subscription" "sku_indexing_sub" {
  name  = "${var.project_name}-sku-indexing-sub"
  topic = google_pubsub_topic.events_standby.id
}

# ==============================================================================
# CAMADA 4 & 5: BANCO RELACIONAL + VETORIAL (CLOUD SQL POSTGRESQL)
# ==============================================================================
resource "google_sql_database_instance" "cloudsql_pgvector" {
  name             = "${var.project_name}-cloudsql-dr"
  database_version = "POSTGRES_16"
  region           = var.gcp_region

  settings {
    tier              = "db-custom-2-7680"
    availability_type = "REGIONAL"
  }

  deletion_protection = false
}

# ==============================================================================
# CAMADA 5: BANCO NOSQL (BIGTABLE)
# ==============================================================================
resource "google_bigtable_instance" "nosql_standby" {
  name          = "${var.project_name}-bt-dr"
  instance_type = "DEVELOPMENT"

  cluster {
    cluster_id   = "${var.project_name}-bt-cluster"
    zone         = "${var.gcp_region}-a"
    storage_type = "SSD"
  }
}

# ==============================================================================
# CAMADA 6: OBSERVABILIDADE (CLOUD MONITORING ALERT POLICY)
# ==============================================================================
resource "google_monitoring_alert_policy" "standby_health" {
  display_name = "Quantum Commerce DR - GKE Health"
  combiner     = "OR"

  conditions {
    display_name = "GKE CPU High"
    condition_threshold {
      filter          = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/cpu/core_usage_time\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
    }
  }
}