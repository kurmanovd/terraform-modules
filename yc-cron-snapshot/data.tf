data "archive_file" "cloud-functions-archive-files" {
  type = "zip"
  output_path = "${path.module}/src.zip"
  source_dir = "${path.module}/src"
}