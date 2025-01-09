variable "vpc_cidr" {
  type = string
}
variable "subnets" {
  type = map(object({
    public_ip = bool
    az        = number
  }))
}
