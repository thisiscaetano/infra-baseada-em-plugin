module "gke" {
  source                     = "../modulo/gke"
  project_id                 = var.project_id
  project_id_number          = var.project_id_number
  name                       = var.cluster_name
  region                     = local.region
  zones                      = local.zones
  network_project_id         = var.network_project_id
  network                    = var.vpc
  subnetwork                 = var.subnetwork
  master_ipv4_cidr           = var.master_ipv4_cidr
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = false
  regional                   = true
  remove_default_node_pool   = true
  default_max_pods_per_node  = var.default_max_pods_per_node
  release_channel            = var.release_channel

  node_pools = [
    {
      name               = var.node_name
      machine_type       = var.machine_type
      node_locations     = local.nodes_regions
      min_count          = var.node_as_min
      max_count          = var.node_as_max
      local_ssd_count    = 0
      disk_size_gb       = 60
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      spot               = true
      service_account    = "${var.project_id_number}-compute@developer.gserviceaccount.com"
      initial_node_count = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default_values = local.tags
  }

  node_pools_metadata = {
    all = {}

    default_values = {}
  }

}