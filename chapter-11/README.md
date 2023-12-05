# Miscellaneous Services

## AWS Config

Some common use case for using AWS Config include:

- Audit IAM polices to ensure permissions are not too wide
- Detect if CloudTrail has been disabled
- Detect if EC2 instances are create using unapproved AMIS
- Detect if EBS volumes are encrypted
- Detect if Security Groups are open to the public (e.g. publish ssh access)
- Detect if RDS DBs are public

## AWS Trusted Advisor

Trusted Advisor inspects your AWS environment, and then makes recommendations when opportunities exist to save money, improve system availability and performance, or help close security gaps.

If you have a Basic or Developer Support plan, you can use the Trusted Advisor console to access all checks in the Service Limits category and six checks in the Security category.

If you have a Business, Enterprise On-Ramp, or Enterprise Support plan, you can use the Trusted Advisor console and the AWS Trusted Advisor API to access all Trusted Advisor checks

## AWS Cost Explorer

AWS Cost Explorer is a tool that enables you to view and analyse your costs and usage. You can explore your usage and costs using several pre-defined graphs.

You can also create reports that analyse cost and usage data for individual accounts and multiple accounts, as well as at a resource level.

Estimated costs are also provided, based upon previous usage.

### AWS Cost Anomaly Detection

AWS Cost Anomaly Detection is an AWS Cost Management feature, that uses machine learning models to detect and alert on anomalous spend patterns in your deployed AWS services.

The service is able to monitor resources that have been previously tagged, and send an anomaly detection report, with root cause analysis.

Notifications can be send via SNS on a daily or weekly basis.

## AWS Well-Architected Tool

AWS Well-Architected Too is a tool that provides a consistent process for measuring your architecture using AWS best practices. You will need to answer a series of questions and review the responses to help improve the architecture of the application.

### AWS Well-Architected Framework

AWS Well-Architected helps cloud architects build secure, high-performing, resilient, and efficient infrastructure for a variety of applications and workloads. 

The Well-Architected framework is built around six pillars:

- Cost Optimisation
- Performance Efficiency
- Reliability
- Security
- Operational Excellence
- Sustainability

## AWS Audit Manager

Audit Manager helps you continuously audit your AWS usage to simplify how you assess risk and compliance with regulations and industry standards

Audit Manager continuously audits AWS services against frameworks such as GDPR, and will generate reports of compliance with evidence folders.

Audit Manager integrates with Security Hub, AWS Config, Control Tower, CloudTrail and License Manager, and can be run across multiple account using AWS Organisations.

## AWS Service Catalog

Service Catalog enables organisations to create and manage catalogs of IT services that are approved for AWS. These IT services can include everything from virtual machine images, servers, software, databases, and more to complete multi-tier application architectures.

AWS Service Catalog allows for solutions to be installed within AWS accounts that follow organisation guileless and best practices, such as naming conventions, tag policies etc.

An administrator will create a product which are CloudFormation templates that are stored in a catalog. Users can view each product within the catalogue, and launch them accordingly.

## AWS Resource Access Manager (RAM)

AWS Resource Access Manager (RAM) provides customers a simple way to share their resources across AWS accounts or within their AWS Organisation.

You are able to share VPC Subnets, which allows for resources to be deployed from different accounts into the same subnet. Additionally you can share Transit Gateway, Route 53 Resolve Rules and License Manager, although these will not appear on the exam.

Each account is responsible for it own resources, and is not able to view view or modify other account resources within the same VPC Subnet.

The only sharing that occurs is at the network level, i.e. they can talk to each other using their own Private IPs.

Security Groups can be referenced between accounts if needed, but security groups cannot be shared between accounts.

You are unable to shared the default VPC.

**Exam Tip:** If you are presented with a question about sharing VPC subnets, the answer will involve AWS RAM. 







