variable "app_name" {
  default = "my-app"
}

variable "environment" {
  default = "dev"
}

variable "primary_region" {
  type = string
}

variable "replica_region" {
  type = string
}