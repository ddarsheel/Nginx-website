
module "ecr" {
  source = "../../../modules/ecr"
  repo_name="nginximages"
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}
