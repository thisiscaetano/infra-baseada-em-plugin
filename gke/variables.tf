data "google_compute_subnetwork" "gke_subnetwork" {
  name    = var.subnetwork
  region  = local.region
  project = var.network_project_id
}

variable "project_id" {
  type    = string
  default = ""
}

variable "project_id_number" {
  type    = string
  default = ""
}

variable "network_project_id" {
  type    = string
  default = "c4-shared-vpcs-br"
}

variable "vpc" {
  type    = string
  default = "c4-networks-ip-range-base-br"
}

variable "subnetwork" {
  type    = string
  default = ""
}

variable "compute_engine_service_account" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = "-compute@developer.gserviceaccount.com"
}

variable "gke_service_account" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = "@container-engine-robot.iam.gserviceaccount.com"
}

variable "cloud_services_account" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
  default     = "@cloudservices.gserviceaccount.com"
}

variable "cluster_name" {
  type    = string
  default = ""
}

variable "machine_type" {
  type    = string
  default = "e2-standard-4"
}

variable "master_ipv4_cidr" {
  default = ""
}

variable "ip_range_pods" {
  type        = string
  description = "The _name_ of the secondary subnet ip range to use for pods"
  default     = ""
}

variable "ip_range_services" {
  type        = string
  description = "The _name_ of the secondary subnet range to use for services"
  default     = ""
}

variable "node_as_min" {
  type    = number
  default = 1
}

variable "node_as_max" {
  type    = number
  default = 2
}

variable "node_name" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = "prd"
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = "STABLE"
}

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  default     = 30
}