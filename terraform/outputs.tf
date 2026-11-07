output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The IP address of the GKE cluster Kubernetes control plane"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "kubeconfig_command" {
  description = "Command to configure kubectl credentials for the cluster"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}

output "kubeconfig" {
  description = "Kubeconfig configuration for cluster access"
  sensitive   = true
  value = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = google_container_cluster.primary.name
    clusters = [{
      name = google_container_cluster.primary.name
      cluster = {
        server                     = "https://${google_container_cluster.primary.endpoint}"
        certificate-authority-data = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
      }
    }]
    contexts = [{
      name = google_container_cluster.primary.name
      context = {
        cluster = google_container_cluster.primary.name
        user    = google_container_cluster.primary.name
      }
    }]
    users = [{
      name = google_container_cluster.primary.name
      user = {
        exec = {
          apiVersion         = "client.authentication.k8s.io/v1beta1"
          command            = "gke-gcloud-auth-plugin"
          provideClusterInfo = true
        }
      }
    }]
  })
}
