

# resource "google_container_cluster" "default" {
#   name = "my-gke-cluster"

#   location                 = "us-central1"
#   enable_autopilot         = false
#   enable_l4_ilb_subsetting = true

#   network    = "gitops-vpc"
#   subnetwork = "subnet-01"
#   initial_node_count = 2
#   # Set `deletion_protection` to `true` will ensure that one cannot
#   # accidentally delete this instance by use of Terraform.
#   deletion_protection = false
#   node_config {
#     preemptible  = true
#     machine_type = "e2-medium"

#     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
#     service_account = "gitops-sa@gitops-project-424508.iam.gserviceaccount.com"
#     oauth_scopes    = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }


# google_client_config and kubernetes provider must be explicitly specified like the following.

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "gitops-project-424508"
  name                       = "gke-cluster"
  region                     = "us-central1"
  zones                      = ["us-central1-c"]
  network                    = "gitops-vpc"
  subnetwork                 = "subnet-01"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  ip_range_pods              = "subnet-01-secondary-01"
  ip_range_services          = "subnet-02-secondary-02"


  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-medium"
      node_locations            = "us-central1-c"
      min_count                 = 1
      max_count                 = 3
      local_ssd_count           = 0
      spot                      = false
      disk_size_gb              = 80
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      logging_variant           = "DEFAULT"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "gitops-sa@gitops-project-424508.iam.gserviceaccount.com"
      preemptible               = false
      initial_node_count        = 80
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}










# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "19.19.1"

#   cluster_name    = local.cluster_name
#   cluster_version = "1.27"

#   vpc_id                         = module.vpc.vpc_id
#   subnet_ids                     = module.vpc.private_subnets
#   cluster_endpoint_public_access = true

#   eks_managed_node_group_defaults = {
#     ami_type = "AL2_x86_64"

#   }

#   eks_managed_node_groups = {
#     one = {
#       name = "node-group-1"

#       instance_types = ["t3.small"]

#       min_size     = 1
#       max_size     = 3
#       desired_size = 2
#     }

#     two = {
#       name = "node-group-2"

#       instance_types = ["t3.small"]

#       min_size     = 1
#       max_size     = 2
#       desired_size = 1
#     }
#   }
# }
