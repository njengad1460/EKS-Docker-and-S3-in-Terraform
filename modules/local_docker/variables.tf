variable "image_name" {
  description = "Docker image"
  type = string
  default = "nginx:latest"
}

variable "container_name" {
  description = "Container Name"
  type = string
  default = "terraform-nginx"
}

variable "internal_port" {
  description = "Container Port"
  type = number
  default = 80
}

variable "external_port" {
  description = "Host Port"
  type = number
  default = 8080
}