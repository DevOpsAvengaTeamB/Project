variable "ami" {
    description="The type of ami (Ubuntu 20.04 )"
    type = string
    default="ami-0767046d1677be5a0"
}

variable "instance_type" {
    description = "The type of EC2 instance to run (t2.medium)"
    type = string
}

/*
variable "subnet" {
    description = "Location in runge of subnets"
    type = string
}

variable "vpc_id" {
    description = "ID vpc"
    type = string
}
*/

variable "security_group"{
    description ="ID security group"
    type= string
}
