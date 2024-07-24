resource "google_service_account" "google_service_account" {
  project      = var.project_id
  account_id   = var.service_account_name
  display_name = var.service_account_name
  description  = var.service_account_name
}

resource "google_service_account" "google_service_account_obs" {
  project      = var.project_id
  account_id   = var.service_account_name_obs
  display_name = var.service_account_name_obs
  description  = var.service_account_name_obs
}

resource "google_service_account_key" "google_service_account_key" {
  service_account_id = google_service_account.google_service_account.name
  private_key_type   = var.private_key_type

}
resource "google_service_account_key" "google_service_account_key_obs" {
  service_account_id = google_service_account.google_service_account_obs.name
  private_key_type   = var.private_key_type

}
resource "google_project_iam_member" "project_iam_member" {
  project = var.project_id
  role    = var.role
  member  = "serviceAccount:${google_service_account.google_service_account.email}"

  depends_on = [google_service_account.google_service_account]
}

resource "google_project_iam_member" "project_iam_member_obs" {
  project = var.project_id
  role    = var.role_obs
  member  = "serviceAccount:${google_service_account.google_service_account_obs.email}"

  depends_on = [google_service_account.google_service_account_obs]
}
resource "kubernetes_namespace" "external-secrets" {
  metadata {
    name = var.kubernetes_namespace
  }
}
resource "kubernetes_namespace" "obs" {
  metadata {
    name = var.kubernetes_namespace_obs
  }
}
resource "kubernetes_secret" "gcpsm-secret" {
  metadata {
    name      = var.kubernetes_secret
    namespace = kubernetes_namespace.external-secrets.metadata[0].name
  }

  data = {
    "secret-access-credentials" = base64decode(google_service_account_key.google_service_account_key.private_key)
  }

  depends_on = [kubernetes_namespace.external-secrets]
}
resource "kubernetes_secret" "loki-access-gcs" {
  metadata {
    name      = var.kubernetes_secret_obs
    namespace = kubernetes_namespace.obs.metadata[0].name
  }

  data = {
    "key.json" = base64decode(google_service_account_key.google_service_account_key_obs.private_key)
  }

  depends_on = [kubernetes_namespace.external-secrets]
}