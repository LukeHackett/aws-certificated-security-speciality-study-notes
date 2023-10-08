# Creating Your Security Journey in AWS

The AWS Shared Responsibility model outlines who is responsible for part of the cloud. AWS implements, operates, manages, and controls its infrastructure security components, from physical facilities to the virtualisation layer.

With AWS being responsible for the security of the cloud, you remain accountable for security in the cloud. Therefore, you continue to develop the process of defining security controls and adopting best practices but with new and powerful tools in your hands.

With a good understanding of the AWS security services, you will be able to evaluate how the landscape of your current security controls can be leveraged, adapted, or redefined as you make your first steps toward the cloud.



## Where to Start?

Understanding your organisation's current security, compliance and privacy practices as well as regulation and compliance requirements in your industry, is essential to understanding how much effort is required to implement security within the cloud. 

Once you understand such prerequisites, then you can perform an assessment of which security practices and controls that you can (or must) effectively migrate to the cloud, which ones can be optimised, or which ones should be fully transformed.

Based upon the outcomes of the assessment, you will be able to choose a security framework, and follow it throughout your cloud security journey.



## Mapping Security Controls

Cloud security design can start with the analysis of how AWS native security services and features (as well as third-party security solutions) can replace your traditional security controls.

The table below compares the controls that are commonly deployed on traditional on-premise data centres and potential AWS Cloud controls.

| Traditional Security Control                                 | Potential AWS Security Control                               |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Network segregation (such as firewall rules <br/>and router access control lists) | Security groups and network ACLs, <br/>Web Application Firewall (WAF) |
| Data encryption at rest                                      | Amazon S3 server-side encryption, Amazon EBS <br/>encryption, Amazon RDS encryption, among other <br />AWS KMS-enabled enabled encryption features |
| Monitor intrusion and implementing security <br/>controls at the operating system level | Third-party solutions, including endpoint detection and<br/>response (EDR), antivirus (AV), and host intrusion <br />prevention system (HIPS), anomaly detection, user and <br />entity behaviour analytics (UEBA), patching |
| Role-based access control (RBAC)                             | AWS IAM, Active Directory integration through IAM<br/>groups, temporary security credentials, AWS Organisations |
| Environment isolation                                        | Multi-account strategy and AWS Organisations                 |



## Example Phased Security Journey

This section introduces a cloud journey example with three phases for a theoretical organisation to implement as part of their Cloud Security journey:

- Phase 1: Infrastructure Protection
- Phase 2: Security Insights and Workload Protection
- Phase 3: Security Automation

Each of the following sections proposes changes to the cloud environments to help increase the overall security posture of the organisation.  

### Phase 1: Infrastructure Protection

Phase 1 focuses upon deducing who does what within the Cloud, and focuses upon the following actions:

- Define and implement a multi-account model to isolate different departments (and their workloads). AWS Control Tower can be used to setup and control multi-account AWS environments.
- Protect your root accounts (enabling MFA, preventing root access keys, and no daily activities using the root account)
- Guarantee that your root accounts have the correct email addresses for all contacts (with corporate email addresses, not personal ones)
- Integrate user authentication with a single point of truth (e.g. Microsoft Active Directory) to create new cloud administration users via a profile with predefined roles
- Implement MFA for all users who will access the AWS Console
- Use service control policies at the right AWS Organisations level to protect specific resources and accounts
- Centralise and protect your AWS CloudTrail logs by sending all logs into a centralised monitoring account
- Within your VPCs and subnets, create network ACLs and security groups to control not only inbound traffic but also outbound traffic

- Implement an end-to-end encryption strategy using AWS Key Management Service (KMS) to protect data in your buckets, storage, and databases

- Turn on Amazon GuardDuty to help you improve your awareness regarding common attacks in your environment, and ensure that it is being monitored by a team

- Turn on helpful AWS Config basic rules, such as identifying critical open ports such as SSH (22) and RDP (3389) and having them closed automatically

- If your organisation has a Security Operations Centre (SOC), consider integrating the AWS CloudTrail logs and alerts into your traditional log solution

- Run AWS Trusted Advisor periodically in your organisation's accounts so that you can evaluate the basic security controls in your AWS Cloud environment

- Use AWS Systems Manager Session Manager or Amazon EC2 Instance Connect to access your Linux instances, and do not expose the SSH port to all Internet IP addresses on the planet
- Consider using S3 Block Access and IAM Access Analyzer to give you more visibility about possible incorrect access configurations

### Phase 2: Security Insights and Workload Protection

In phase 2, the security controls your team will deploy in AWS are more focused on the applications your organisation is running in the cloud, and include the following actions:

- Amazon EC2 instances should be patched as per the patch and compliance strategy. EC2 Image Builder can be used to help create secure images.

- Amazon Inspector and AWS Patch Manager can be used together to help increase your patch posture visibility and automate the mitigation processes.

- Enabling AWS Security Hub to receive all alerts from Amazon GuardDuty, AWS Config and Amazon Inspector will provide a single pane of glass to evaluate security findings and prioritise your actions.

- You will also need to define your end-point security strategy. Select the most appropriate anti-malware and endpoint detection and response (EDR) that you will use in your instances.

- AWS Shield Standard, AWS Shield Advanced, AWS WAF, Amazon Route 53, AWS Auto Scaling, Amazon API Gateway, and Cloud Front can all be used to help mitigate DDoS attacks
- Credentials (such as database passwords) should be stored in AWS Secrets Manager and rotated frequently.

### Phase 3: Security Automation

Phase 3 promotes implementing security as code and security automation strategies such as:

- Integrate security code evaluation into your pipelines, using Static Application Security Testing (SAST) and Dynamic Application Security Testing (DAST) technologies to protect your applications. Amazon Code Guru and AWS partners can help with to improve your code security evaluation process.

- Validating your AWS CloudFormation templates (or other IAC mechanisms) to detect insecure configurations such as unauthorised open ports, open buckets, and cleartext passwords.

- You can leverage AWS Serverless services to automate incident response processes, ensuring that the Cloud Operation, infrastructure, Security Operation, and DevSecOps teams are involved in it's development.

- Prepare and train incident response processes in advance, by creating runbooks and playbooks, as well as considering executing gamedays and cyberattack simulations. Do not wait for a real incident to prepare your team.
