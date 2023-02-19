module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version      = "24.1.0"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}

module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version           = "24.1.0"
  project_id        = var.project_id
  name              = "${var.cluster_name}-${var.env_name}"
  regional          = false
  region            = var.region
  zones             = var.gke_zones
  network           = module.gcp-network.network_name
  subnetwork        = module.gcp-network.subnets_names[0]
  ip_range_pods     = var.ip_range_pods_name
  ip_range_services = var.ip_range_services_name

  node_pools = [
    {
      name           = "node-pool"
      machine_type   = "e2-medium"
      node_locations = var.gke_zones[0] #"europe-west1-b,europe-west1-c,europe-west1-d"
      autoscaling    = false
      auto_upgrade   = false
      # min_count                 = 1
      # max_count                 = 2
      disk_size_gb    = 50
      disk_type       = "pd-standard"
      image_type      = "COS_CONTAINERD"
      local_ssd_count = 0
      node_count      = 2
    },
  ]
}