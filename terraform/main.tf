provider "google" {
  project     = var.project_id
  region      = var.region


}
# resource "google_storage_bucket" "my-bucket" {
#   name                     = "no-public-access-bucket-m"
#   location                 = "US"
#   force_destroy            = true
#   public_access_prevention = "enforced"

# }



