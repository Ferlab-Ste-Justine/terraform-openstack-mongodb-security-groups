resource "openstack_networking_secgroup_v2" "mongodb_replicaset_member" {
  name                 = "mongodb-replicaset-member-${var.namespace}"
  description          = "Security group for mongodb replicaset members"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "mongodb_client" {
  name                 = "mongodb-client-${var.namespace}"
  description          = "Security group for the clients connecting to mongodb replicaset members"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_v2" "mongodb_bastion" {
  name                 = "mongodb-bastion-${var.namespace}"
  description          = "Security group for the bastion connecting to mongodb replicaset members"
  delete_default_rules = true
}

//Allow all outbound traffic from mongodb members and bastion
resource "openstack_networking_secgroup_rule_v2" "mongodb_replicaset_member_outgoing_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "mongodb_replicaset_member_outgoing_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "mongodb_bastion_outgoing_v4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.mongodb_bastion.id
}

resource "openstack_networking_secgroup_rule_v2" "mongodb_bastion_outgoing_v6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.mongodb_bastion.id
}

//Allow port 27017 traffic from other members
resource "openstack_networking_secgroup_rule_v2" "peer_mongodb_replicaset_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 27017
  port_range_max    = 27017
  remote_group_id  = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

//Allow port 22 traffic from the bastion
resource "openstack_networking_secgroup_rule_v2" "internal_ssh_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id  = openstack_networking_secgroup_v2.mongodb_bastion.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

//Allow port 22 traffic on the bastion
resource "openstack_networking_secgroup_rule_v2" "external_ssh_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.mongodb_bastion.id
}

//Allow port 2379 traffic from the client
resource "openstack_networking_secgroup_rule_v2" "client_mongodb_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 27017
  port_range_max    = 27017
  remote_group_id  = openstack_networking_secgroup_v2.mongodb_client.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

//Allow clients and bastion to use icmp
resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id  = openstack_networking_secgroup_v2.mongodb_client.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id  = openstack_networking_secgroup_v2.mongodb_client.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id  = openstack_networking_secgroup_v2.mongodb_bastion.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id  = openstack_networking_secgroup_v2.mongodb_bastion.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_external_icmp_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.mongodb_bastion.id
}