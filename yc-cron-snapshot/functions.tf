################################################
##
##  Yandex Cloud Functions
##
################################################

// Upload functions (zip) to bucket
resource "yandex_storage_object" "cloud-functions-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-functions-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-functions-static-key.secret_key
  bucket = var.bucket-name
  key    = "cloud-functions-object"
  source = data.archive_file.cloud-functions-archive-files.output_path
  
  depends_on = [
    yandex_storage_bucket.functions-object-storage
  ]
}

// Create function (spawn-snapshot-tasks)
resource "yandex_function" "spawn-snapshot-tasks" {
  name               = "spawn-snapshot-tasks"
  description        = "Add message to Yandex Queue"
  user_hash          = data.archive_file.cloud-functions-archive-files.output_sha
  runtime            = "golang117"
  entrypoint         = "spawn-snapshot-tasks.SpawnHandler" 
  memory             = "128"
  execution_timeout  = "30"
  service_account_id = yandex_iam_service_account.sa-functions.id
  tags = []
  environment = {
    FOLDER_ID   = local.folder_id
    MODE        = var.mode
    TTL         = var.ttl
    AWS_ACCESS_KEY_ID = yandex_iam_service_account_static_access_key.sa-functions-static-key.access_key
    AWS_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.sa-functions-static-key.secret_key
    QUEUE_URL = yandex_message_queue.snapshot_queue.id
  }
  package {
    bucket_name = yandex_storage_bucket.functions-object-storage.bucket
    object_name = yandex_storage_object.cloud-functions-object.key
  }
  depends_on = [
    yandex_storage_object.cloud-functions-object,
    yandex_message_queue.snapshot_queue
  ]
}

// Create function (snapshot-disks-tasks)
resource "yandex_function" "snapshot-disks-tasks" {
  name               = "snapshot-disks-tasks"
  description        = "Snapshot Disks"
  user_hash          = data.archive_file.cloud-functions-archive-files.output_sha
  runtime            = "golang117"
  entrypoint         = "snapshot-disks.SnapshotHandler" 
  memory             = "128"
  execution_timeout  = "60"
  service_account_id = yandex_iam_service_account.sa-functions.id
  tags = []
  environment        = {
    TTL         = var.ttl
  }
  package {
    bucket_name = yandex_storage_bucket.functions-object-storage.bucket
    object_name = yandex_storage_object.cloud-functions-object.key
  }
  depends_on = [
    yandex_storage_object.cloud-functions-object
  ]
}

// Create function (delete-expired-tasks)
resource "yandex_function" "delete-expired-tasks" {
  name               = "delete-expired-tasks"
  description        = "Delete Expired Snapshots"
  user_hash          = data.archive_file.cloud-functions-archive-files.output_sha
  runtime            = "golang117"
  entrypoint         = "delete-expired.DeleteHandler" 
  memory             = "128"
  execution_timeout  = "60"
  service_account_id = yandex_iam_service_account.sa-functions.id
  tags = []
  environment        = {
    FOLDER_ID   = local.folder_id
  }
  package {
    bucket_name = yandex_storage_bucket.functions-object-storage.bucket
    object_name = yandex_storage_object.cloud-functions-object.key
  }
  depends_on = [
    yandex_storage_object.cloud-functions-object
  ]
}

// iam_binding
resource "yandex_function_iam_binding" "function-iam-spawn-snapshot-tasks" {
  function_id = yandex_function.spawn-snapshot-tasks.id
  role        = "serverless.functions.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.sa-functions.id}",
  ]

  depends_on = [
    yandex_function.spawn-snapshot-tasks
  ]
}

resource "yandex_function_iam_binding" "function-iam-snapshot-disks-tasks" {
  function_id = yandex_function.snapshot-disks-tasks.id
  role        = "serverless.functions.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.sa-functions.id}",
  ]

  depends_on = [
    yandex_function.snapshot-disks-tasks
  ]
}

resource "yandex_function_iam_binding" "function-iam-delete-expired-tasks" {
  function_id = yandex_function.delete-expired-tasks.id
  role        = "serverless.functions.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.sa-functions.id}",
  ]

  depends_on = [
    yandex_function.delete-expired-tasks
  ]
}