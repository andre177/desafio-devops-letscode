terraform {
  backend "s3" {
    bucket = "ada-devops-challenge"
    key    = "ada-devops-challenge-tfstates"
    region = "us-east-1"
  }
}