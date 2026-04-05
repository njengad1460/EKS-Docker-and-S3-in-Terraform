module "s3_replicated" {
  source = "../../modules/s3_replicated"

  app_name    = var.app_name
  environment = var.environment

  providers = {
    aws.primary = aws.primary
    aws.replica = aws.replica
  }
}

module "docker" {
  source = "../../modules/local_docker"

  image_name     = "nginx:latest"
  container_name = "terraform-nginx"
  external_port  = 8080
}


module "eks" {
  source = "../../modules/eks_cluster"

  cluster_name = "${var.app_name}-cluster"
  environment  = var.environment

  providers = {
    aws = aws.primary
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}


resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx-deployment"
    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
