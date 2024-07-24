locals {
  zones                  = var.environment == "prd" ? ["us-east1-b", "us-east1-c", "us-east1-d"] : ["us-east1-b"]
  region                 = "us-east1"
  nodes_regions          = var.environment == "prd" ? "us-east1-b,us-east1-c,us-east1-d" : "us-east1-b"
  maintenance_start_time = "2021-10-17T08:00:00Z"
  maintenance_end_time   = "2021-10-18T08:00:00Z"

  tags = {

    cloud_provider = "gcp"
    owner       = "you"
    env         = "prd"

  }
}
