


# versions.tf
terraform {
  required_version = ">= 1.3"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

# providers.tf
provider "kubernetes" {
  host                   = "https://kubernetes.default.svc"
  token                  = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
  cluster_ca_certificate = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
  #load_config_file =false
}

provider "helm" {
  kubernetes {
    host                   = "https://kubernetes.default.svc"
    token                  = file("/var/run/secrets/kubernetes.io/serviceaccount/token")
    cluster_ca_certificate = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
  }
}



resource "helm_release" "redis" {
  name      = "redis"
  namespace = "app-env"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "19.5.0"
}

resource "helm_release" "webapp1" {
  name      = "webapp1"
  namespace = "app-env"

  chart = "${path.module}/helm1/webapp1"

  values = [
    file("${path.module}/helm1/webapp1/values.yaml")
  ]
}



# outputs.tf
output "redis_status" {
  value = helm_release.redis.status
}

output "redis_namespace" {
  value = helm_release.redis.namespace
}






