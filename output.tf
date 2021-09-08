output "groups" {
  value = {
    replicaset_member = openstack_networking_secgroup_v2.mongodb_replicaset_member
    client = openstack_networking_secgroup_v2.mongodb_client
    bastion = openstack_networking_secgroup_v2.mongodb_bastion
  }
}