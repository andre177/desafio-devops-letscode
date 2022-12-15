terraform {
  backend "s3" {
    bucket = "ada-devops-challenge"
    key    = "ada-devops-challenge-private-tfstates"
    region = "us-east-1"
  }
}