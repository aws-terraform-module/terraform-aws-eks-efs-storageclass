# Resource: Kubernetes Storage Class
resource "kubernetes_storage_class_v1" "efs_sc" {  
  metadata {
    name = "efs-sc-${var.efs_name}"
  }
  storage_provisioner = "efs.csi.aws.com"  
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId =  aws_efs_file_system.efs_file_system.id 
    directoryPerms = "700"
    gidRangeStart = "1000" # optional
    gidRangeEnd = "2000" # optional
    basePath = "/dynamic_provisioning" # optional
    gid = var.gid
    uid = var.uid
  }
}