################################################
##
##  Yandex Cloud Backet for Cloud Functions
##
################################################

// Use keys to create bucket
resource "yandex_storage_bucket" "functions-object-storage" {
  access_key = yandex_iam_service_account_static_access_key.sa-functions-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-functions-static-key.secret_key
  bucket = var.bucket-name

  depends_on = [
    yandex_iam_service_account.sa-functions
  ]
}