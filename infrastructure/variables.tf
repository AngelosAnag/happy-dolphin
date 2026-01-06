variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "happy-dolphin"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "playground"
    Repository  = "happy-dolphin"
    Owner       = "Angelos Anagnostopoulos"
    Terraform   = "true"
  }
}

variable "instances" {
  description = "Map of instances to create"
  type        = map(string)
  default = {
    "web-server" = "t3.micro"
    "api-server" = "t3.small"
    "worker"     = "t3.medium"
  }
}

variable "public_instance_type" {
  description = "Instance type for the public server"
  type        = string
  default     = "t3.micro"
}

variable "private_instance_type" {
  description = "Instance type for the private server"
  type        = string
  default     = "t3.micro"
}

variable "isolated_instance_type" {
  description = "Instance type for the isolated server"
  type        = string
  default     = "t3.micro"
}

variable "main_vpc_cidr" {
  description = "CIDR block for the demo VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "demo_public_subnet_cidr" {
  description = "CIDR block for the demo public subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "demo_public_subnet_az" {
  description = "Availability zone for the demo public subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "demo_private_subnet_cidr" {
  description = "CIDR block for the demo private subnet"
  type        = string
  default     = "10.20.2.0/24"
}

variable "demo_private_subnet_az" {
  description = "Availability zone for the demo private subnet"
  type        = string
  default     = "eu-central-1b"
}

variable "demo_isolated_subnet_cidr" {
  description = "CIDR block for the demo isolated subnet"
  type        = string
  default     = "10.20.3.0/24"
}

variable "demo_isolated_subnet_az" {
  description = "Availability zone for the demo isolated subnet"
  type        = string
  default     = "eu-central-1a"
}

variable "demo_isolated_subnet_2_cidr" {
  description = "CIDR block for the demo isolated subnet 2"
  type        = string
  default     = "10.20.4.0/24"
}

variable "demo_isolated_subnet_2_az" {
  description = "Availability zone for the demo isolated subnet 2"
  type        = string
  default     = "eu-central-1b"
}

