variable "instances" {
  type = map(object({
    public_ip = bool
    key_name  = string
    instance_type = string
  }))
}
variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}