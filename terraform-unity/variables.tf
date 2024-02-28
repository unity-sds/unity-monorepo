variable "project" {
  description = "The project or mission deploying Unity SPS"
  type        = string
  default     = "unity"
}

variable "venue" {
  description = "The MCP venue in which the cluster will be deployed (dev, test, prod)"
  type        = string
  default     = null
}

variable "service_area" {
  description = "The service area owner of the resources being deployed"
  type        = string
  default     = "sps"
}

variable "counter" {
  description = "value"
  type        = string
  default     = ""
}

variable "release" {
  description = "The SPS release version"
  type        = string
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "kubeconfig_filepath" {
  description = "Path to the kubeconfig file for the Kubernetes cluster"
  type        = string
  default     = "../k8s/kubernetes.yml"
}

variable "airflow_webserver_password" {
  description = "value"
  type        = string
}

variable "helm_charts" {
  description = "Settings for the required Helm charts."
  type = map(object({
    repository = string
    chart      = string
    version    = string
  }))
  default = {
    airflow = {
      repository = "https://airflow.apache.org"
      chart      = "airflow"
      version    = "1.11.0"
    },
    keda = {
      repository = "https://kedacore.github.io/charts"
      chart      = "keda"
      version    = "v2.13.1"
    }
  }
}

variable "docker_images" {
  description = "Docker images for the services."
  type = object({
    airflow = object({
      name = string
      tag  = string
    }),
    ogc_processes_api = object({
      name = string
      tag  = string
    })
  })
  default = {
    airflow = {
      name = "ghcr.io/unity-sds/unity-sps/sps-airflow"
      tag  = "develop"
    },
    ogc_processes_api = {
      name = "ghcr.io/unity-sds/unity-sps-ogc-processes-api/unity-sps-ogc-processes-api"
      tag  = "develop"
    }
  }
}
