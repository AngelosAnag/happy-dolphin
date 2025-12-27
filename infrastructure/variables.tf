variable "instances" {
  description = "Map of instances to create"
  type        = map(string)
  default = {
    "web-server"  = "t3.micro"
    "api-server"  = "t3.small"
    "worker"      = "t3.medium"
  }
}