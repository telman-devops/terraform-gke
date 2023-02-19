# provider "google" {
#   credentials = file("itechart-377110-a8d060b568ab.json")
#   project     = "itechart-377110"
#   region      = "europe-west1"
# }

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
  }
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}