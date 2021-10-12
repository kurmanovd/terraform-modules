################################################
##
##  Yandex Cloud Functions Triggers
##
################################################

resource "yandex_function_trigger" "spawn-snapshot-tasks" {
  name        = "spawn-snapshot-tasks"
  description = "spawn-snapshot-tasks"
  timer {
    cron_expression = var.cron-spawn-snapshot-tasks
  }
  function {
    id = yandex_function.spawn-snapshot-tasks.id
    service_account_id = yandex_iam_service_account.sa-functions.id
  }
  depends_on = [
    yandex_function.spawn-snapshot-tasks
  ]
}

resource "yandex_function_trigger" "snapshot-disks-tasks" {
  name        = "snapshot-disks-tasks"
  description = "snapshot-disks-tasks"
  message_queue {
    queue_id = yandex_message_queue.snapshot_queue.arn
    service_account_id = yandex_iam_service_account.sa-functions.id
    batch_cutoff = 1
    batch_size = 1
  }
  function {
    id = yandex_function.snapshot-disks-tasks.id
    service_account_id = yandex_iam_service_account.sa-functions.id
  }
  depends_on = [
    yandex_function.snapshot-disks-tasks,
    yandex_message_queue.snapshot_queue
  ]
}

resource "yandex_function_trigger" "delete-expired-tasks" {
  name        = "delete-expired-tasks"
  description = "delete-expired-tasks"
  timer {
    cron_expression = var.cron-delete-expired-tasks
  }
  function {
    id = yandex_function.delete-expired-tasks.id
    service_account_id = yandex_iam_service_account.sa-functions.id
  }
  depends_on = [
    yandex_function.delete-expired-tasks
  ]
}