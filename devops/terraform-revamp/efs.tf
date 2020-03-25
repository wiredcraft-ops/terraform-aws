resource "aws_efs_file_system" "demo" {

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}