# Resource: Security Group - Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System
resource "aws_security_group" "efs_allow_access" {
  name        = "efs-allow-nfs-from-eks-vpc"
  description = "Allow Inbound NFS Traffic from EKS VPC CIDR"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow Inbound NFS Traffic from EKS VPC CIDR to EFS File System"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_nfs_from_eks_vpc"
  }
}


# Resource: EFS File System
resource "aws_efs_file_system" "efs_file_system" {
  creation_token = "efs-${var.efs_name}"

  throughput_mode = var.throughput_mode
  tags = {
    Name = "efs-${var.efs_name}"
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(var.eks_private_subnets)
  id       = each.value
}

# Extract the AZ ID for each subnet and group by AZ ID
locals {
  # Map subnet ids to their AZ ids
  subnet_az_ids = { for s in data.aws_subnet.subnets : s.id => s.availability_zone_id }

  # Group subnets by AZ, creating a map of AZ IDs to lists of subnets in that AZ
  subnets_by_az = {
    for az in distinct(values(local.subnet_az_ids)) : az => [
      for s_id, az_id in local.subnet_az_ids : s_id if az_id == az
    ]
  }

  # Ensure only one subnet is selected from each AZ for the mount target
  unique_az_subnets = flatten([for az, subnets in local.subnets_by_az : [subnets[0]]]) # pick the first subnet from each AZ
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count = length(local.unique_az_subnets)  # One mount target per unique AZ

  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = local.unique_az_subnets[count.index] # Select subnet for the mount target
  security_groups = [aws_security_group.efs_allow_access.id]
}



# EFS File System ID
output "efs_file_system_id" {
  description = "EFS File System ID"
  value = aws_efs_file_system.efs_file_system.id 
}

output "efs_file_system_dns_name" {
  description = "EFS File System DNS Name"
  value = aws_efs_file_system.efs_file_system.dns_name
}


# EFS Mounts Info
output "efs_mount_target_id" {
  description = "EFS File System Mount Target ID"
  value = aws_efs_mount_target.efs_mount_target[*].id 
}

output "efs_mount_target_dns_name" {
  description = "EFS File System Mount Target DNS Name"
  value = aws_efs_mount_target.efs_mount_target[*].mount_target_dns_name 
}

output "efs_mount_target_availability_zone_name" {
  description = "EFS File System Mount Target availability_zone_name"
  value = aws_efs_mount_target.efs_mount_target[*].availability_zone_name 
}