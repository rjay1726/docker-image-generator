provider "aws" {
    region = var.region
}
#Always Parked - Always Parked
locals {
    park_my_cloud_tag            = { "Automation:PMC" = "PaaStryAlwaysOn", "Technical:PatchingOwner" = "TEAM" }
    tags                         = jsondecode(trimspace(data.aws_ssm_parameter.tags.value))
    ami_id                       = (var.ami_id == null ? data.aws_ssm_parameter.ecs_gold_ami.value : var.ami_id)
}

data "aws_ssm_parameter" "tags" {
    name = "/paastry/configuration/dinuka/tags"
}

data "aws_ssm_parameter" "ecs_gold_ami" {
    name = "/paastry/information/images/paastry_ecs_amzn2"
}

module "ec2_instance_latest" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    version = "~> 3.0"

    name                        = "PAAS-296-GENERATE-DOCKER-IMAGES"
    ami                         = "ami-05c87e206715c6b89"
    instance_type               = var.instance_type
    key_name                    = var.key_name
    vpc_security_group_ids      = [module.security_group.security_group_id]
    subnet_id                   = var.subnet_id
    associate_public_ip_address = false

    tags                        = merge(local.tags, local.park_my_cloud_tag)

    root_block_device = [
        {
            encrypted   = true
            volume_type = "gp3"
            throughput  = 200
            volume_size = 30
        }
    ]

}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = module.ec2_instance_latest.private_ip
}


# module "ec2_instance" {
#     source  = "terraform-aws-modules/ec2-instance/aws"
#     version = "~> 3.0"

#     name                        = "RUSARA-TEST-OLD-AMI"
#     ami                         = "ami-038e15843cefcc1a8"
#     instance_type               = var.instance_type
#     key_name                    = var.key_name
#     vpc_security_group_ids      = [module.security_group.security_group_id]
#     subnet_id                   = var.subnet_id
#     associate_public_ip_address = false

#     tags                        = merge(local.tags, local.park_my_cloud_tag)

#     root_block_device = [
#         {
#             encrypted   = true
#             volume_type = "gp3"
#             throughput  = 200
#             volume_size = 30
#         }
#     ]

# }

# output "old_instance_private_ip" {
#   description = "The private IP address of the OLD EC2 instance"
#   value       = module.ec2_instance.private_ip
# }

module "security_group" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "~> 4.0"

    name                = "${var.instance_name}-sg"
    description         = "Security group for usage with ${var.instance_name} EC2"
    vpc_id              = var.vpc

    ingress_cidr_blocks = ["10.0.0.0/8"]
    ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]
    egress_rules        = ["all-all"]

    tags                = local.tags
}


# module "ubuntu_base_ec2_instance" {
#     source  = "terraform-aws-modules/ec2-instance/aws"
#     version = "~> 3.0"

#     name                        = "RUSARA-TEST-UBUNTU-BASE"
#     ami                         = "ami-07805725cba874a83"
#     instance_type               = var.instance_type
#     key_name                    = "RUSARA"
#     vpc_security_group_ids      = [module.security_group.security_group_id]
#     subnet_id                   = var.subnet_id
#     associate_public_ip_address = false

#     tags                        = merge(local.tags, local.park_my_cloud_tag)

#     root_block_device = [
#         {
#             encrypted   = true
#             volume_type = "gp3"
#             throughput  = 200
#             volume_size = 30
#         }
#     ]

# }

