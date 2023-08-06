# Infrastructure Protection

## AWS Networking Constructs

### VPC


Amazon Virtual Private Cloud (Amazon VPC) is an abstraction that represents a virtual network within the AWS Cloud. Each VPC is associated with an AWS region, and therefore VPCs do not extend beyond a region.

A VPC consists of at least one range of contiguous IP addresses — i.e. a Classless Inter-Domain Routing (CIDR) block

Any IP range can be used for a VPC CIDR but it best to use one of the following RFC1918 ranges to avoid conflicts with public Internet addresses:

- `10.0.0.0 – 10.255.255.255 (10.0.0.0/8)`
- `172.16.0.0 – 172.31.255.255 (172.16.0.0/12)`
- `192.168.0.0 – 192.168.255.255 (192.168.0.0/16)`

A VPC can configured with two tenancy types:

- **Default**: Amazon EC2 instances that are deployed in this VPC will share hardware with other AWS accounts.
- **Dedicated:** Amazon EC2 instances deployed in a dedicated VPC will run on hardware dedicated to a single tenant (i.e. a single AWS Account)

The choice between either option depends on various factors such as compliance regulations or existing software license specifics

### Subnet

A *subnet* represents a range of IP addresses in your VPC. Resources that are deployed into a subnet will inherit traffic policies that are applied to the subnet. A subnet is located within a single AZ.

Not all IP Addresses with a subnet are assignable, three IP addresses are reserved for AWS usage:

- **Second Address** is reserved for the VPC router (i.e. 10.0.10.1) 
- **Third Address** is reserved for the DNS server (i.e. 10.0.10.2) 
- **Fourth Address** is reserved for future use (i.e. 10.0.10.3) 

Each subnet will have an associated Route Table, in which routing rules can be added. By default, all routing tables will provide a routing mechanism for resources within the subnet.

### Internet Gateway

An Internet gateway is a scalable, redundant, and highly available VPC component that allows communication between instances in your VPC and the Internet.

There are two types of Internet gateways in the AWS Cloud:

- **Internet Gateways** provide a target in your VPC route tables for Internet-routable traffic (default route). They also perform network address translation (NAT) for instances that have been assigned public IPv4 addresses, and they support IPv6 traffic.
- **Egress Only Internet Gateways** are only used to enable outbound IPv6 traffic from the VPC.

Internet gateways are attached to a VPC, and can be used by multiple subnets. In order for a subnet to use an Internet gateway, a default route pointing to the Internet Gateway will need to be setup, e.g. `0.0.0.0/0` would point to the Internet Gateway



## Network Address Translation

Network Address Translation (NAT) is a mechanism to map one (or more) private IP Addresses to a single public IP address before transmitting the request out to the internet.

The purpose of a NAT device is to allow an instance to access the Internet while preventing hosts on the Internet from reaching the instance directly.

### NAT Gateway

- A NAT gateway is a NAT device managed by AWS - it scales to accommodate your bandwidth requirements
- A NAT gateway must be assigned an EIP, and can only reside in only one subnet. It is possible to deployment NAT gateways in multiple subnets across AZs for redundancy.
- After creating a NAT gateway, you must create a default route to direct Internet-bound traffic from your instances to the NAT gateway
- Because a NAT gateway doesn’t use an ENI, you can’t apply a security group to it. You can, however, apply an NACL to the subnet that it resides in.

### NAT Instance

- A NAT instance is a normal EC2 instance that uses a pre-configured Linux-based AMI, however there are some differences to a NAT Gateway:
  - A NAT instance doesn’t automatically scale to accommodate increased bandwidth requirements (if its not correct, you need to manually upgrade to a larger instance)
  - It is not possible to have multiple NAT Instances (e.g. using a auto-scaling group)
  - You also must remember to assign it a public IP address
  - You must disable Source/Destination checks on the NAT instance so that it can handle packets that were not originally destined for the NAT instance.
  - A NAT instance will need a security group associated to it, which will need to be changed accordingly when new resources are added into subnets. 
- NAT instances do have some advantages, such as:
  - Being configured as a bastion host to connect to instances that don’t have a public IP.
  - Custom port forwarding rules can be configured, such as sending traffic on port 8000 to a private server listening on port 9000
- NAT gateways are considered more appropriate and secure for enterprise-class designs apart from the circumstances outlined above.



## Security Groups

A *security group* is a virtual firewall that controls inbound and outbound traffic on an elastic network interface (ENI). Each rule can be defined in terms of IP addresses, transport protocols (TCP or UDP), and ports that will define which type of communication your instance can receive or transmit.

The source or destination in a rule can be any CIDR, and the source can also be the resource ID of a security group. Each security group contains a hidden rule that will denies every connection that is not defined in previous rules. The ordering of rules within a security group, does not affect the evaluation.

Security groups are *stateful*, which means that return traffic from an allowed inbound connection is automatically permitted to leave the instance, i.e. you do not have to define a corresponding outbound rule to allow it.

Each ENI can support up to five security groups per network interface. When multiple security groups are attached to the same ENI, the rules from each security group are effectively aggregated to create a unique set of rules as if they belonged to a single security group.



## Network Access Control Lists

Network access control lists (NACLs) are network traffic control objects that act as firewalls when traffic enters or leaves a subnet in your VPC. The extra layer of traffic filtering can be used to prevent unexpected traffic between subnets, regardless of what is deployed in the subnets.

A subnet can only have one NACL associated with it, and by default the VPC's default NACL is used if a NACL is not specified when creating a subnet. Each VPC has a default NACL that cannot be deleted.

A NACL is stateless, meaning that it doesn’t use connection tracking and doesn’t automatically allow reply traffic — you'll often need to explicitly open Ephemeral ports for example.

Rules within a NACL are evaluated starting with the lowest numbered rule, when a rule matches traffic, it is immediately applied independently of any higher-numbered rule that may contradict it.



## Elastic Load Balancing

AWS offers three types of load balancing services under the name *Elastic Load Balancing*: *Application Load Balancer*, *Network Load Balancer*, and *Classic Load Balancer*. 

Each type of Elastic Load Balancing implementations follow the same basic architecture:

- **Target** represents instances or IP Addresses (as well as the protocol and port)  from AWS resources that will receive the connections that the load balancer is dispatching.
- **Health Checks** synthetic requests that verify whether an application is available to accept connections. These requests can accept HTTP/HTTPS, TCP, TLS and UDP.
- **Target Group** is a group of instances, IP Address or AWS Lambda functions that deploy the same application, user the same health check and are balanced via a load-balancing algorithm such as *round robin* or *least outstanding requests* (uses the target with the fewest connections)
- **Listener** is an entity that checks for connection requests from clients, using the configured protocol and port - this is informally known as a virtual IP (VIP).
- **Stickiness** is an optional feature that ensures a user's session is bound to a specific target, ensuring that all requests from the user are handled by the same target. The stickiness can have a duration of between one second and seven days.

Additionally, all types of Elastic Load Balancers support Amazon CloudWatch metrics, logging, availability zone fail-over, cross-zone load balancing, SSL offloading, and backend server encryption.

### Application Load Balancer (ALB)

An ALB operates at levels 5 to 7 of the OSI model, and are defined to load-balance web traffic. An ALB can also be used to improve the security of application by ensuring that the latest ciphers and protocols are used.

An ALB provides additional functionality such as:

- slow start (to avoid target overload when they are included in a target group)
- Source IP address CIDR-based routing
- Routing based on parameters such as path, host, HTTP header and method, query string
- Redirects and fixed responses

ALB supports AWS Lambda functions as targets as well as user authentication.

### Network Load Balancer (NLB)

An NLB operates at level 4 of the OSI model, routing connections based on IP and TCP or UDP protocol data. It is capable of handling millions of requests per second while maintaining ultra-low latencies. 

An NLB provides additional functionality such as:

- the use of static IP address, elastic IP address
- preservation of the client source IP address (for logging purposes)

### Classic Load Balancer (CLB)

A CLB enables basic load balancing across Amazon EC2 instances. A CLB is intended for applications that were built within the EC2-Classic network. 

Exclusive CLB features include the support of the EC2-Classic platform as well as custom security policies.



## VPC Endpoints

*VPC endpoints* allow for private connections to AWS services from within your VPC, without imposing additional traffic on your Internet gateways or relying on the Internet for such communication. 

There are two types of VPC endpoints:

- **Gateway endpoint** is a gateway that you specify as a target for a route in your route table for traffic destined to AWS services such as Amazon S3 and Amazon DynamoDB
- **Interface endpoint** is an elastic network interface with a private IP address on a subnet that serves as an entry point for traffic between this subnet and AWS services (such as EMR, ECS, KMS etc).



## VPC Flow Logs



## AWS Web Application Firewall



## AWS Shield



