module "folders" {
  source = "./terraform"
}


# resource "google_storage_bucket" "my-bucket" {
#   name                     = "no-public-access-bucket-m"
#   location                 = "US"
#   force_destroy            = true
#   public_access_prevention = "enforced"
#   project                  = "gitops-project-424508"
# }