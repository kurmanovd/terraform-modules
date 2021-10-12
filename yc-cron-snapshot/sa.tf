################################################
##
##  Service Account
##
################################################

// Create SA
resource "yandex_iam_service_account" "sa-functions" {
  folder_id = local.folder_id
  name      = "terraform-functions"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-functions-editor" {
  folder_id = local.folder_id
  role      = "editor"  # Без этих прав нельзя создать Message Queue
  member    = "serviceAccount:${yandex_iam_service_account.sa-functions.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-functions-static-key" {
  service_account_id = yandex_iam_service_account.sa-functions.id
  description        = "static access key for object storage"
}