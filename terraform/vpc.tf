resource "google_compute_network" "default" {
  name = "example-network"

  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "default" {
  name = "example-subnetwork"

  ip_cidr_range = "10.0.0.0/12"
  region        = "us-central1"

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL" # Change to "EXTERNAL" if creating an external loadbalancer

  network = google_compute_network.default.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.0.1.0/12"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "10.0.2.0/12"
  }
}

 
# module "vpc" {
#   source  = "terraform-google-modules/network/google"
#   version = "~> 9.1"

#   project_id   = "gitops-project-424508"
#   network_name = "gitops-vpc"
#   routing_mode = "GLOBAL"

#   subnets = [
#     {
#       subnet_name           = "subnet-01"
#       subnet_ip             = "10.10.10.0/24"
#       subnet_region         = "us-central1"
#     },
#     {
#       subnet_name           = "subnet-02"
#       subnet_ip             = "10.10.20.0/24"
#       subnet_region         = "us-central1"
#       subnet_private_access = "true"
#       subnet_flow_logs      = "true"
#       description           = "This subnet has a description"
#     },
#     {
#       subnet_name               = "subnet-03"
#       subnet_ip                 = "10.10.30.0/24"
#       subnet_region             = "us-central1"
#       subnet_flow_logs          = "true"
#       subnet_flow_logs_interval = "INTERVAL_10_MIN"
#       subnet_flow_logs_sampling = 0.7
#       subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
#     }
#   ]

#   secondary_ranges = {
#     subnet-01 = [
#       {
#         range_name    = "subnet-01-secondary-01"
#         ip_cidr_range = "192.168.64.0/24"
#       },
#       {
#         range_name    = "subnet-01-secondary-02"
#         ip_cidr_range = "192.168.74.0/24"
#       }
#     ]
#   }

#   routes = [
#     {
#       name                   = "egress-internet"
#       description            = "route through IGW to access internet"
#       destination_range      = "0.0.0.0/0"
#       tags                   = "egress-inet"
#       next_hop_internet      = "true"
#     },
#     {
#       name                   = "app-proxy"
#       description            = "route through proxy to reach app"
#       destination_range      = "10.50.10.0/24"
#       tags                   = "app-proxy"
#       next_hop_instance      = "app-proxy-instance"
#       next_hop_instance_zone = "us-central1-c"
#     },
#   ]
# }
# resource "google_compute_subnetwork" "existing_subnetwork" {
#   name          = "gke-subnetwork"
#   ip_cidr_range = "10.0.0.0/20"
#   region        = "us-central1"
#   network       = module.vpc.network_self_link

#   secondary_ip_range {
#     range_name    = "gke-subnetwork-pods"
#     ip_cidr_range = "10.1.0.0/16"
#   }

#   secondary_ip_range {
#     range_name    = "gke-subnetwork-services"
#     ip_cidr_range = "10.2.0.0/20"
#   }
# }
