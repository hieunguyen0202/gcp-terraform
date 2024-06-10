# Define variables
variable "project_id" {
  description = "The ID of the project in which to create the GKE cluster"
  type        = string
  default     = "gitops-project-424508"
  
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gitops-gke"
}
variable "credentials_file_path" {
  description = "Path to the Google Cloud credentials JSON file"
  type        = string
  default     = "keys.json"
}