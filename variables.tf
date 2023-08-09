variable "namespace" {
  description = "Namespace to create the resources under"
  type = string
  default = ""
}

variable "bastion_security_group_id" {
  description = "Id of pre-existing security group to add bastion rules to"
  type = string
  default = ""
}
