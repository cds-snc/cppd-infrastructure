locals {
  common_tags = {
    CsdId          = "930"
    Branch         = "IITB"
    Classification = var.classification
    Directorate    = "BSIM"
    Environment    = var.environment
    Project        = "DTS"
    ServiceOwner   = var.service_owner
    Version        = var.infra_version
  }
  pgadmin_account = "psqladmin"
  nameprefix      = "Es${var.environmentprefix}${var.locationprefix}${var.name}"
}
