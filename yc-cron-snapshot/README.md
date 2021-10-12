# Terraform Yandex.Cloud Cron Snapshot Module

Простой Terraform модуль для создания снимков дисков в Yandex.Cloud по расписанию

Используются сервисы:

* Object Storage
* Cloud Functions
* Message Queue

Исходники функций [nikolaymatrosov](https://github.com/nikolaymatrosov/go-yc-serverless-snapshot)

## Пример использования

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
      bucket-name               = "moneycare-buh-1c-functions-object-storage"
      cron-spawn-snapshot-tasks = "5 3 * * ? *"
      cron-delete-expired-tasks = "0 6 * * ? *"
      ttl                       = 604800
      mode                      = "all"
    }
  ]
}
```
