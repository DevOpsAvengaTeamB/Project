output "vpc_id" {
    description= "ID vpc"
    value=module.network.vpc-id
}

output "subnet"{
    description="ID private subnet in a"
    value=module.network.subnet-priv-a-id
}