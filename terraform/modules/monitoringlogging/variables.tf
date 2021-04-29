variable "cluster_name" {
    description = "The name for all monitoring resources"
    type= string
}

variable "instance_count"{
    description="Count of instances"
    type=number

variable "ami" {
    description="The type of ami"
    type = string
}

variable "instance_type" {
    description = "The type of EC2 instance to run (t2.medium)"
    type = string
}

variable "subnet" {
    description = "Location in runge of subnets"
    type = string
}

variable "security_group"{
    description ="ID security group"
    type= string
}

variable "security_group_rules" {
    description="My rules in the security group"
    type=list

}