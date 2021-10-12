################################################
##
##  Yandex Message Queue
##
################################################

resource "yandex_message_queue" "snapshot_queue" {
  name                        = "snapshot-queue"
  access_key = yandex_iam_service_account_static_access_key.sa-functions-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-functions-static-key.secret_key
  
  depends_on = [
    yandex_iam_service_account.sa-functions
  ]
}
