# # Terraform Remote State Datasource - Remote Backend AWS S3
# # EKS Cluster Project
# data "terraform_remote_state" "eks" {
#   backend = "s3"
#   config = {
#     bucket = "terraform-on-aws-eks-nim"
#     key    = "dev/eks-cluster/terraform.tfstate"
#     region = "us-east-1" 
#   }
# }

variable "efs_name" {
  description = "Input Name of efs and storageClass"
  type = string
  default = ""
}

variable "eks_cluster_id" {
  description = "EKS cluster ID/data.terraform_remote_state.eks.outputs.cluster_id"
  type = string
  default = ""
}

variable "eks_cluster_endpoint" {
  description = "The hostname (in form of URI) of Kubernetes master/data.terraform_remote_state.eks.outputs.cluster_endpoint"
  type = string
  default = ""
}

variable "eks_cluster_certificate_authority_data" {
  description = "PEM-encoded root certificates bundle for TLS authentication./data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data"
  type = string
  default = ""
}

variable "vpc_id" {
  description = "The ID of the VPC that is installed EKS Cluster"
  type = string
  default = ""
}

//###https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest#output_vpc_cidr_block
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type = string
  default = ""
}



variable "eks_private_subnets" {
  description = "EKS Private Subnet"
  type = list(string)
  default = ["69.69.69.0/24", "06.05.1994.0/24"]
}


variable "gid" {
  description = "The default group ID for the provisioned directories. This determines the group ownership of the EFS volume."
  type = number
  default = 1000
}
variable "uid" {
  description = "The default user ID for the provisioned directories. This determines the user ownership of the EFS volume."
  type = number
  default = 1000
}


variable "throughput_mode" {
  description = "(Optional) Throughput mode for the file system. Defaults to elastic. Valid values: `bursting`, or `elastic`."
  type = string
  default = "elastic"
}