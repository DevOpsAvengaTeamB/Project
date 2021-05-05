# Terraform

![Terraform Logo](https://files.readme.io/baae34e-terraform-logo.png)

Terraform is an open-source infrastructure as code software tool created by HashiCorp. Users define and provide data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language (HCL), or optionally JSON.

#### Requirements:

| Name | Version |
|------|---------|
| terraform | > 0.12.08 |

#### Providers:

| Name | Version |
|------|---------|
| aws | latest |

## Modules:
1. [Backend](https://github.com/DevOpsAvengaTeamB/Project/tree/main/terraform/modules/Backend)
1. [Frontend](https://github.com/DevOpsAvengaTeamB/Project/tree/main/terraform/modules/frontend)
1. [Instances](https://github.com/DevOpsAvengaTeamB/Project/tree/main/terraform/modules/instances)
1. [Jenkins](https://github.com/DevOpsAvengaTeamB/Project/tree/main/terraform/modules/jenkins)
1. [Logging/monitoring](https://github.com/DevOpsAvengaTeamB/Project/tree/main/terraform/modules/monitoringlogging)
1. [Network](https://github.com/DevOpsAvengaTeamB/Project/tree/main/terraform/modules/network)
1. [Security](https://github.com/DevOpsAvengaTeamB/Project/tree/main/terraform/modules/security)

## `Module: Backend`

**Outputs:**

| Name | Description | Value |
|------|-------------|-------| 
| DBpassword | *none* | aws_db_instance.postgresql.password |
| Backend | Private ip of backend | aws_instance.Backend.private_ip |
| DB | Private ip of db | aws_db_instance.postgresql.address |

**Variables:**

| Name | Type | Description | Default |
|------|------|-------------|-------| 
| ami | string | Ubuntu 20.04 | ami-08962a4068733a2b6 |
| web_private_ip | string | *none* | *none* |
| vpc-id | string | *none* | *none* |
| subnet-priv-a-id | string | *none* | *none* |
| subnet-priv-b-id | string | *none* | *none* |

## `Module: Frontend`

**Outputs:**

| Name | Description | Value |
|------|-------------|-------| 
|  |  |  |

**Variables:**

| Name | Type | Description | Default |
|------|------|-------------|-------| 
|  |  |  |  |

## `Module: Instances`

**Outputs:**

| Name | Description | Value |
|------|-------------|-------| 
|  |  |  |

**Variables:**

| Name | Type | Description | Default |
|------|------|-------------|-------| 
|  |  |  |  |

## `Module: Jenkins`

**Outputs:**

| Name | Description | Value |
|------|-------------|-------| 
|  |  |  |

**Variables:**

| Name | Type | Description | Default |
|------|------|-------------|-------| 
|  |  |  |  |

## `Module: Logging/monitoring`

**Outputs:**

| Name | Description | Value |
|------|-------------|-------| 
|  |  |  |

**Variables:**

| Name | Type | Description | Default |
|------|------|-------------|-------| 
|  |  |  |  |

## `Module: Network`

**Outputs:**

| Name | Description | Value |
|------|-------------|-------| 
|  |  |  |

**Variables:**

| Name | Type | Description | Default |
|------|------|-------------|-------| 
|  |  |  |  |

## `Module: Security`

**Outputs:**

| Name | Description | Value |
|------|-------------|-------| 
|  |  |  |

**Variables:**

| Name | Type | Description | Default |
|------|------|-------------|-------| 
|  |  |  |  |
