// Variable for the VPC CIDR block range.
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

// Variable for the subnet CIDR block range.
variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}
