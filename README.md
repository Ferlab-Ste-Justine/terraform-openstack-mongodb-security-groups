# About

This is a terraform module that provisions security groups meant to be restrict network access to a mongodb replicaset.

The following security groups are created:
- **member**: Security group for members of the mongodb replicaset. It can make external requests and communicate with other members of the **member** group on port **27017**
- **client**: Security group for any machine that needs to talk to the mongodb replicaset as a client. It can communicate with any member of the **member** group on port **27017** and send them **icmp** traffic as well.
- **bastion**: Security group to any machine that needs **ssh** access to the mongodb replicaset. It can communicate with any member of the **member** group on port **22** and send them **icmp** traffic as well. I can also make any external request, receive external **icmp** traffic and receive external requests on port **22**.

The **member** and **bastion** security groups are self-contained. They can be applied by themselves on vms with no other security groups and the vms will be functional in their role.

The **client** security group is meant to supplement other security groups a vm will have as the only thing it grants is client access to the mongodb replicaset.

# Usage

## Variables

The module takes the following variables as input:
- **namespace**: Namespace to differenciate the security group names across mongodb replicasets. The generated security groups will have the following names:
    ```
    <namespace>-mongodb-member
    <namespace>-mongodb-client
    <namespace>-mongodb-bastion
    ```
- **bastion_security_group_id**: Id of pre-existing security group to add bastion rules to (defaults to "")

- **fluentd_security_group**: Optional fluentd security group configuration. It has the following keys:
  - **id**: Id of pre-existing security group to add fluentd rules to
  - **port**: Port the remote fluentd node listens on

## Output

The module outputs the following variables as output:

- groups: A map with 3 keys: client, member, bastion. Each key map entry contains a resource of type **openstack_networking_secgroup_v2**