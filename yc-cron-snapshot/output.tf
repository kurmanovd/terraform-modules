output "yandex_message_queue_url" {
  value = yandex_message_queue.snapshot_queue.id
}

output "yandex_message_queue_arn" {
  value = yandex_message_queue.snapshot_queue.arn
}