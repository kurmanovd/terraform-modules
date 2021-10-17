# Terraform Yandex.Cloud Cron Snapshot Module

A simple Terraform module for creating disk snapshots in Yandex.Cloud on crone

## Requirements

* Terraform v1.0.7+
* Go 1.16 (Cloud Functions)

## Yandex.Cloud Services

* Service Account
* Object Storage
* Cloud Functions
* Message Queue

## Using the module

main.tf

```terraform
module "cron-snapshot-module" {
  source                    = "git@github.com:kurmanovd/terraform-modules.git//yc-cron-snapshot"
  folder_id                 = var.provider-folder-id
  bucket-name               = var.cron-snapshot-module-vars.0.bucket-name
  cron-spawn-snapshot-tasks = var.cron-snapshot-module-vars.0.cron-spawn-snapshot-tasks
  cron-delete-expired-tasks = var.cron-snapshot-module-vars.0.cron-delete-expired-tasks
  ttl                       = var.cron-snapshot-module-vars.0.ttl
  mode                      = var.cron-snapshot-module-vars.0.mode
}
```

vars.tf

```terraform
variable "cron-snapshot-module-vars" {
  type = list(object({
    bucket-name               = string
    cron-spawn-snapshot-tasks = string
    cron-delete-expired-tasks = string
    ttl                       = number
    mode                      = string
  }))
  default = [
    {
      bucket-name               = "my-functions-object-storage"
      cron-spawn-snapshot-tasks = "5 3 * * ? *"
      cron-delete-expired-tasks = "0 6 * * ? *"
      ttl                       = 604800
      mode                      = "all"
    }
  ]
}
```

## Update the Module

```bash
terraform get -update  # Update modules
terraform taint module.cron-snapshot-module.yandex_storage_object.cloud-functions-object  # Force recreate Object
```
Force recreate obkect