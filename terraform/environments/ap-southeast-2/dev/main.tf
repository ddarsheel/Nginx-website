
variable "ecr_repository_url" {
  default = "011528262341.dkr.ecr.ap-southeast-2.amazonaws.com/nginximages"
}

module "security_group" {
  source = "../../../modules/securitygroup"
  vpc_id = "vpc-07c071f68d8948d2d"
}

module "ec2" {
  source              = "../../../modules/ec2"
  ec2_role_name       = "test"
  ami_id              = "ami-03f0544597f43a91d"
  instance_type       = "t3.micro"
  security_group_id   = module.security_group.security_group_id
  region              = "ap-southeast-2"
  ecr_repository_url  = var.ecr_repository_url
  key_pair_name       = "darsheeltest"
  subnet_id         = "subnet-0d9fa8cae0d703fa1"
}

/*module "autoscaling" {
  source              = "../../../modules/autoscalinggroup"
  launch_configuration_id = module.ec2.launch_configuration_id
  subnet_ids          = ["subnet-0d9fa8cae0d703fa1","subnet-0306b03c038492793","subnet-094bfc46d3359dbd1"]
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  #target_group_arn    = [module.alb.target_group_arn]
}*/

/*module "alb" {
  source = "../../../modules/alb"
  name               = "web-loadbalancer"
  security_groups    = [module.security_group.security_group_id]
  subnets            = ["subnet-0d9fa8cae0d703fa1","subnet-0306b03c038492793","subnet-094bfc46d3359dbd1"]
  logs_bucket        = "logbucketdar"
  enable_logs        = true
  certificate_arn    = "arn:aws:acm:ap-southeast-2:011528262341:certificate/e076a7c2-e88a-4998-a092-2a5689d4b497"
  vpc_id             = "vpc-07c071f68d8948d2d"
}

resource "aws_route53_record" "web" {
  zone_id = "Z02444052ZGNVBBKDK8AD"
  name    = "darsheeltest.com"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}
*/


output "security_group_id" {
  value = module.security_group.security_group_id
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}
