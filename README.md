# About

This is a terraform module that provisions security groups meant to be restrict network access to a mongodb replicaset.

The following security group is created:
- **member**: Security group for members of the mongodb replicaset. It can make external requests and communicate with other members of the **member** group on port **27017**

Additionally, you can pass a list of groups that will fulfill each of the following roles:
- **bastion**: Security groups that will have access to the mongodb servers on port **22** as well as icmp traffic.
- **client**: Security groups that will have access to the mongodb servers on port **27017** as well as icmp traffic.
- **metrics_server**: Security groups that will have access to the mongodb servers on ports **9100** as well as icmp traffic.

# Usage

## Variables

The module takes the following variables as input:

- **member_group_name**: Name to give to the security group for the members of the mongodb replicaset
- **client_group_ids**: List of ids of security groups that should have **client** access to the mongodb replicaset
- **bastion_group_ids**: List of ids of security groups that should have **bastion** access to the mongodb replicaset
- **metrics_server_group_ids**: List of ids of security groups that should have **metrics server** access to the mongodb replicaset

## Output

The module outputs the following variables as output:

- **member_group**: Security group for the mongodb replicaset that got created. It contains a resource of type **openstack_networking_secgroup_v2**