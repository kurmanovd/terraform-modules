################################################
##
##  Yandex Cloud Cron Snapshot Module
##
##  Provision:
##      - Service Account for Object Storage
##      - Object Storage for Cloud Functions
##      - Message Queue
##      - 3x Cloud Functions
##      - 3x Triggers
##
##  Made by Denis Kurmanov, 10.2021
##
################################################

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
}

locals {
  folder_id = var.folder_id
}