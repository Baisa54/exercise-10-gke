variable "project_id" {
  type        = string
  description = "The Google Cloud Platform project ID"
}

variable "region" {
  type        = string
  description = "GCP region where GKE cluster and resources will be created"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "GCP zone within the region for cluster resources"
  default     = "us-central1-a"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
  default     = "node-registry-cluster"
}

variable "machine_type" {
  type        = string
  description = "Machine type for the GKE cluster worker nodes"
  default     = "e2-medium"
}

variable "node_count" {
  type        = number
  description = "Initial number of worker nodes in the node pool"
  default     = 2
}
