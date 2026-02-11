variable "vpc_id" {}
variable "subnet_id" {}
variable "ami_id" {
  default = "ami-0b6c6ebed2801a5cb" 
}
variable "instance_type" {
  default = "t3.medium"
}