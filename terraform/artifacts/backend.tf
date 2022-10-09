terraform {
  backend "s3" {
    key            = "artifacts/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-state-locking"
  }
}
