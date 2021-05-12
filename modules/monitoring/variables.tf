variable "vpc_id" {
    description = "ID vpc"
    type = string
}

variable "ami" {
    description="The type of ami (Ubuntu 20.04 ) eu-west-3"
    type = string
    default="ami-0f7cd40eac2214b37"
}

variable "instance_type" {
    description = "The type of EC2 instance to run (t2.medium)"
    type = string
    default="t2.medium"
}

variable "subnet_id"{
    description="Runge
}

/*
variable "subnet-priv-a-id" {
    description = "Location in a private subnet"
    type=string
}

variable "subnet-priv-b-id" {
    description = "Location in b private subnet"
    type=string
}
*/


