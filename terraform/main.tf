resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Remove default node pool to manage worker nodes separately
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network configuration supporting container-native load balancing
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {}

  # Workload Identity configuration for pod authentication
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      app         = "node-registry"
      environment = "production"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
