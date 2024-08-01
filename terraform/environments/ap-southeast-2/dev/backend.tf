terraform {
  backend "s3" {
    bucket = "darsheel-terraformbackup"
    key    = "dev/main.tfstate"
    region = "ap-southeast-2"
  }
}
