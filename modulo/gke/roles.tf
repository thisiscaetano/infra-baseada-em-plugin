data "google_compute_default_service_account" "compute_engine" {}
module "shared_roles" {
  source   = "../iam/modules/projects_iam"
  mode     = "additive"
  projects = [var.network_project_id, var.project_id]
  bindings = {

    "roles/compute.networkUser" = [
      "serviceAccount:${var.project_id_number}${var.compute_engine_service_account}",
      "serviceAccount:service-${var.project_id_number}${var.gke_service_account}",
      "serviceAccount:${var.project_id_number}${var.cloud_services_account}"
    ]

    "roles/container.hostServiceAgentUser" = [
      "serviceAccount:${var.project_id_number}${var.compute_engine_service_account}",
      "serviceAccount:service-${var.project_id_number}${var.gke_service_account}"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:${var.atlantis}"
    ]

    "roles/iam.serviceAccountCreator" = [
      "serviceAccount:${var.atlantis}"
    ]

    "roles/container.serviceAgent" = [
      "serviceAccount:${var.atlantis}"
    ]
  }
}

resource "google_project_iam_binding" "artifact_devops" {
  project = "br-carrefour-devops"
  members = ["serviceAccount:${data.google_compute_default_service_account.compute_engine.email}"]
  role = "roles/artifactregistry.admin"

 depends_on = [ module.shared_roles ] 
}

