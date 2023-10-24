resource "openstack_networking_secgroup_v2" "mongodb_replicaset_member" {
  name                 = var.member_group_name
  description          = "Security group for mongodb replicaset members"
  delete_default_rules = true
}

//Allow all outbound traffic from mongodb members
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

//Allow port 27017 traffic from other members
resource "openstack_networking_secgroup_rule_v2" "peer_mongodb_replicaset_access" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 27017
  port_range_max    = 27017
  remote_group_id   = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

//Allow port 22 and icmp traffic from the bastion groups
resource "openstack_networking_secgroup_rule_v2" "bastion_ssh_access" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v4" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_access_v6" {
  for_each          = { for idx, id in var.bastion_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

//Allow port 27017 and icmp traffic from the client
resource "openstack_networking_secgroup_rule_v2" "client_mongodb_access" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 27017
  port_range_max    = 27017
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v4" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "client_icmp_access_v6" {
  for_each          = { for idx, id in var.client_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

//Allow port 9100 and icmp traffic from metrics server
resource "openstack_networking_secgroup_rule_v2" "metrics_server_node_exporter_access" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_icmp_access_v4" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}

resource "openstack_networking_secgroup_rule_v2" "metrics_server_icmp_access_v6" {
  for_each          = { for idx, id in var.metrics_server_group_ids : idx => id }
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "ipv6-icmp"
  remote_group_id   = each.value
  security_group_id = openstack_networking_secgroup_v2.mongodb_replicaset_member.id
}