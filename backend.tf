terraform {
  backend "gcs" {
    bucket = "itechart-storage-s3"
    prefix = "dev-state"
  }
}
