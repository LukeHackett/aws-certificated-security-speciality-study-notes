# Security Automation

As threats are always evolving in terms of complexity and volume, many organisations find it challenging to rely on a large team of specialists looking at dashboards to manage the emerging threats.

Security Automation's goal is to help to take some of the load away from security engineers, so that more complex challenges can be focused upon.

Automation can:

- Swiftly improve the consistency of security controls;
- Revert undesirable configuration drifts;
- Correct insecure configurations configurations that are usually caused by human error;
- Increase the speed of containment in the security incident response process

The actions performed in an automatic response to a security event, will reduce the risk exposure by minimising the window in which malicious actors can perform their activities.



## Event-Driven Security

When analysing existing incident response playbooks, a logical sequence of events often appears:

![event-driven-security](./event-driven-security.png)

1. A detective control receives data from one or more data sources. Common data sources include:
   - **Logs:** AWS CloudTrail, DNS records, VPC flow logs, web application firewall logs, operating systems logs, application logs or AWS CloudWatch logs.
   - **Infrastructure:** Configurations or inventory
   - **Data:** Amazon S3 buckets data analytics

2. Using rules or machine intelligence, the detective control recognises an undesired condition and triggers an event, such as a Amazon CloudWatch Event, a finding in AWS Security Hub, or a ticket in the Incident Response Platform tool. Examples of detective capabilities include:
   - Amazon GuardDuty
   - AWS Config
   - Amazon Inspector
   - Amazon Macie
   - AWS IAM Access Analyzer

   Additionally, the following finds and events are frequently used to trigger an automated response:

   - Unsafe configurations (from AWS Config or Amazon Inspector) such as open buckets RDP/SSH open to all IPs etc
   - AWS Security Hub findings from 3rd Parties, such as antivirus software
   - Potential security indigents such as connections to anonymisation networks, e.g. TOR
   - Anomalies in the usage of Amazon EC2 resources, such as crypto-mining malware (which aims to max out CPU and GPU usage)
   - Any event from Amazon CloudWatch Events can trigger a response task

3. A response task is triggered that contains the threat in which the security team are alerted and/or resolves the configuration drift automatically. Common response tasks include:

   - An AWS Lambda function can use AWS APIs to change security groups or network ACLs
   - Systems Manager Automation documents can be used to correct configuration drifts detected by AWS Config
   - OS level actions can be performed by Systems manager Run Commands against multiple hosts at scale (e.g. patching an operating system)
   - Responses that require coordination between automated and human responses can make use of AWS Step Functions to follow a workflow of actions.

Amazon S3 supports event-driven security processes via executing an AWS Lambda function when changes to files, metadata or other events within an S3 bucket. For example, log files can be parsed by S3 as they arrive to detect potential security issues or to add a malicious actor to a black list.

Another example is that at the creation of a new file (PUT operation), we can trigger an AWS Lambda function that analyses the file looking for malware or sends the file to a malware sandboxing system for analysis.

