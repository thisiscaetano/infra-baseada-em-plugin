resource "google_compute_firewall" "intra_egress" {
  count       = var.add_cluster_firewall_rules ? 1 : 0
  name        = "gke-${substr(var.name, 0, min(25, length(var.name)))}-intra-cluster-egress"
  description = "Managed by terraform gke module: Allow pods to communicate with each other and the master"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "EGRESS"

  target_tags = [local.cluster_network_tag]
  destination_ranges = [
    local.cluster_endpoint_for_nodes,
    local.cluster_subnet_cidr,
    local.cluster_alias_ranges_cidr[var.ip_range_pods],
  ]

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

  depends_on = [
    google_container_cluster.primary,
  ]
}


resource "google_compute_firewall" "master_webhooks" {
  count       = var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules ? 1 : 0
  name        = "gke-${substr(var.name, 0, min(25, length(var.name)))}-webhooks"
  description = "Managed by terraform gke module: Allow master to hit pods for admission controllers/webhooks"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  source_tags   = []
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = var.firewall_inbound_ports
  }

  depends_on = [
    google_container_cluster.primary,
  ]

}


resource "google_compute_firewall" "shadow_allow_pods" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(25, length(var.name)))}-all"
  description = "Managed by terraform gke module: A shadow firewall rule to match the default rule allowing pod communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_alias_ranges_cidr[var.ip_range_pods]]
  target_tags   = [local.cluster_network_tag]

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "shadow_allow_master" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(25, length(var.name)))}-master"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["10250", "443"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "shadow_allow_nodes" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(25, length(var.name)))}-vms"
  description = "Managed by Terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_subnet_cidr]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
