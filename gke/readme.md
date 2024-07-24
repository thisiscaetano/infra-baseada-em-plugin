# Terraform GKE Module

Este módulo Terraform cria um cluster do Google Kubernetes Engine (GKE).

## Uso

```
module "gke" {
  source                     = "git@bitbucket.org:carrefour_ecommerce/module-tf.git//gke_v2"
  project_id                 = var.project_id
  project_id_number          = var.project_id_number
  name                       = var.name
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
```
## Inputs

| Nome                      | Descrição                                            | Tipo   | Default | Obrigatório |
|---------------------------|------------------------------------------------------|--------|---------|-------------|
| `project_id`              | ID do projeto GCP                                    | string | n/a     | sim         |
| `project_id_number`       | Número do ID do projeto GCP                          | string | n/a     | sim         |
| `name`                    | Nome do cluster                                      | string | n/a     | sim         |
| `region`                  | Região do cluster                                    | string | n/a     | sim         |
| `zones`                   | Zonas do cluster                                     | list   | n/a     | sim         |
| `network_project_id`      | ID do projeto da rede                                | string | n/a     | sim         |
| `network`                 | Nome da rede VPC                                     | string | n/a     | sim         |
| `subnetwork`              | Nome da sub-rede                                     | string | n/a     | sim         |
| `master_ipv4_cidr`        | CIDR IPv4 do master                                  | string | n/a     | sim         |
| `ip_range_pods`           | Intervalo de IPs para os pods                        | string | n/a     | sim         |
| `ip_range_services`       | Intervalo de IPs para os serviços                    | string | n/a     | sim         |
| `http_load_balancing`     | Ativar balanceamento de carga HTTP                   | bool   | true    | não         |
| `horizontal_pod_autoscaling` | Ativar escalonamento horizontal de pods           | bool   | true    | não         |
| `network_policy`          | Ativar política de rede                              | bool   | false   | não         |
| `regional`                | Cluster regional                                     | bool   | true    | não         |
| `remove_default_node_pool` | Remover o pool de nós padrão                        | bool   | true    | não         |
| `default_max_pods_per_node` | Número máximo de pods por nó padrão                | number | n/a     | sim         |
| `release_channel`         | Canal de lançamento do cluster                       | string | n/a     | sim         |
| `node_pools`              | Configurações dos pools de nós                       | list   | n/a     | sim         |
| `node_pools_oauth_scopes` | Escopos OAuth para os pools de nós                   | map    | n/a     | sim         |
| `node_pools_labels`       | Rótulos para os pools de nós                         | map    | n/a     | sim         |
| `node_pools_metadata`     | Metadados para os pools de nós                       | map    | n/a     | sim         |

## Outputs

| Nome           | Descrição                           |
|----------------|-------------------------------------|
| `project_id`   | ID do projeto GCP                   |
| `cluster_name` | Nome do cluster                     | 
| `region`       | Região do cluster                   | 

