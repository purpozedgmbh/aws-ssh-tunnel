variable "vpc_id" {
  type        = string
  description = "The ID of the VPC with original private resources and where to launch the instance in"
}

variable "key_pair_name" {
  type        = string
  description = "The name of the key pair to use for the instance"
}

variable "public_subnet_id" {
  type        = string
  description = "The ID of the public subnet to launch the instance in"
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ids if any to use for the instance"
}

variable "rote53_zone_id" {
  type        = string
  description = "The ID of the Route53 zone to create the readable record in"
}

variable "rote53_zone_domain" {
  type        = string
  description = "The Name/Domain of the Route53 public zone to create the readable record in"
}

variable "bastion_domain_prefix" {
  type        = string
  description = "The prefix of the domain name to use for the bastion host"
  default     = "bastion"
}

variable "instance_type" {
  type        = string
  default     = "t4g.micro"
  description = "The instance type to use for the bastion host"
}

locals {
  bastion_domain = "${var.bastion_domain_prefix}.${var.rote53_zone_domain}"
}
