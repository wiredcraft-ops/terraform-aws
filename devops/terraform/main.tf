provider "aws" {
  version = "~> 2.0"
  region  = var.region

  access_key = data.external.vault.result["aws_access_key"]
  secret_key = data.external.vault.result["aws_secret_key"]
}

# save secrets in ansible-vault file
data "external" "vault" {
  program = ["ansible-vault", "view", "--vault-password-file=../../.vault_password", "./vault.json"]
}
