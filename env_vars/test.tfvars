#VPC
vpc_cidr = "10.0.0.0/16"

#Subnet
subnets = {
  public_subnet_1 = {
    public_ip = true
    az        = 1
  }
  public_subnet_2 = {
    public_ip = true
    az        = 2
  }
  private_subnet_1 = {
    public_ip = false
    az        = 1
  }
  private_subnet_2 = {
    public_ip = false
    az        = 2
  }
}