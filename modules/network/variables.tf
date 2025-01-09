variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr      = string
    public_ip = bool
    az        = number
  }))
}

