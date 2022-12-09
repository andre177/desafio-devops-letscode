data "terraform_remote_state" "base_iac" {
  backend = "s3"
  config = {
    bucket = "ada-devops-challenge"
    key    = "ada-devops-challenge-tfstates"
    region = "us-east-1"
  }
}