variable "folder_id" {
  type    = string
  default = ""
}

variable "bucket-name" {
  type    = string
  default = "cloud-folder-functions-object-storage"
}

# Cron expression must be in AWS cron format
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
variable "cron-spawn-snapshot-tasks" {
  type    = string
  default = "5 3 * * ? *"
}

variable "cron-delete-expired-tasks" {
  type    = string
  default = "0 6 * * ? *"
}

variable "ttl" {
  type    = number
  default = 604800
}

variable "mode" {
  type    = string
  default = "all"
}