variable "instance_name" {
}

variable "vpc" {
    default = "vpc-0c0f1ee888b989da8"
}

variable "instance_type" {
    default = "t2.large"
}

variable "subnet_id" {
    default = "subnet-068277527fd53df9f"
}

variable "key_name" {
    default = "paastry-platform"
}

variable "ami_id" {
    default = null
}

variable "region" {
    default = "us-east-1"
}