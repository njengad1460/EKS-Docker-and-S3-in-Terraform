provider "aws" {
  alias  = "primary"
  region = var.primary_region
}
provider "aws" {
  alias  = "replica"
  region = var.replica_region
}