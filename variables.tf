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

variable "fluentd_security_group" {
  description = "Fluentd security group configuration"
  type        = object({
    id   = string
    port = number
  })
  default = {
    id   = ""
    port = 0
  }
}
