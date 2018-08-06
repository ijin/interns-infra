provider "aws" {
  region     = "ap-northeast-1"
  version    = "~> 1.30.0"
  allowed_account_ids = ["${var.account_id}"]
}

provider "aws" {
  alias = "west"
  region = "us-west-2"
  version    = "~> 1.30.0"
  allowed_account_ids = ["${var.account_id}"]
}

terraform {
  backend "s3" {
    bucket = "sc-interns-terraform"
    key    = "common.tfstate"
    region = "ap-northeast-1"
  }
}
