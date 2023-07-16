# Identity and Access Management


## AWS IAM

AWS Identity and Access Management (IAM) provides a set of APIs that control access to your resources on the AWS Cloud. AWS IAM gives you the ability to define authentication and authorisation methods for using the resources in your account.

### Principals

A *principle* is an AWS IAM entity that has permission to interact with resources in the AWS Cloud. A principal can represent a human user, a resource or an application and the permission can be permanent or temporary.

There are three types of principles, *root users*, *IAM users*, and *roles*.

#### Root Users

A root user provides you unrestricted access to all the AWS resources in your account, such as viewing billing information, changing your root account password, deleting all resources and closing the account.

Daily operations should not use the *root user*, and AWS recommends that your secure your AWS account by following these recommendations:

- Use a strong password on the root user account
- Enable MFA on the root user account
- Do not create access keys using the root account (use another IAM account instead)
- Never share the root user password

#### IAM Users

An *IAM User* is a person or application in your organisation. Each IAM user persist in the account they were created in, but can be granted permissions to other accounts if configured to do so.

Each IAM user has it's own username and password along with access keys to provide programmatic access to AWS resources.

In order to avoid using your root user account, you should create an IAM user for yourself and then assign administrator permissions for your account so that you can add more users when needed.

#### IAM Groups

An *IAM group* is a good way to allow administrators to manage users with similar permissions requirements.

Groups can be created based upon related to job functions or teams such as administrators, developers, QA, FinOps, operations, and so on. Additionally permissions can be assigned to groups, allowing for users who are assigned to the group, to inherit those permissions.

***Note:** An IAM group is not an identity because it cannot be referred to as a principal when you’re setting up permission policies. It is just a logical organisation that allows you to attach policies to multiple users all at once.*

### IAM roles

*IAM roles* have a permission policy that determines what the IAM role can and cannot do in AWS. AN IAM role is not exclusively associated with an IAM user or group; they are assumed by other entities such as IAM users, applications or services.

When an IAM role is assumed, it is granted temporary credentials by the *AWS Security Token Service (STS)*. The temporary credentials are valid throughout the role session usage, have have a lifetime of between 15 minutes and 36 hours (default is 1 hour).

Roles can be used to delegate access to resources that services, applications, or users do not normally have. For example, you can allow an application to assume a role that provides access to a resource in a different AWS account even if its original permissions did not allow such access.

IAM roles can be used in the following scenarios:

- Grant permissions to an IAM user in the same AWS account as the role, or a different account (known as *cross-account access*)
- Grant permissions to applications running on Amazon EC2, which is called *AWS service role for an EC2 instance*.
- In user federation scenarios, it’s possible to use IAM roles to grant permissions to external users authenticated through a trusted IdP.

### AWS Security Token Services

The *AWS Security Token Services (STS)* is designed to provide trusted users and services with temporary security credentials that control access to AWS resources.

The main differences between long-term access keys and temporary security credentials issued by AWS STS are as follows:

- When you issue a temporary security credential, you can specify the expiration interval of that credential, which can range from a few minutes to several hours. 
- Once the temporary credentials are expired, they are are no longer recognised by AWS, and any API requests made with
  them are denied.
- Temporary credentials are dynamic and generated every time a user requests them. A user can renew the temporary credentials before their expiration if they have permission to do so (by assuming the role again).

#### Roles for Cross-Account Access

*Roles for cross-account access* grant users of one AWS account access to resources in a different account.

One common use case can be two AWS accounts, such as *development* and *production*, where users from the *development* account must access resources within *production* account. 

The regular permissions to a developer in the *development* account do not allow them to directly access the resources in the *production* account. In lieu of this, it’s possible to define a trust policy that allows a developer in the *development* account to assume a role in the *production* account. 

First, an IAM role would need to be setup within the *production* account that has the required permissions (see below).

```json
// [Production Account] Role Permission Policy
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::production-account-bucket-name"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::production-account-bucket-name/*"
    }
  ]
}
```

Next the Role's trust policy must allow a user (or a role) from the *development* account to assume the role in the production account:

```json
// [Production Account] Role Trust Policy
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": { 
      "AWS": "arn:aws:iam::development-account-id:root" 
    },
    "Action": "sts:AssumeRole",
  }
}
```

Finally, an IAM role or user will need to be granted permissions to assume the IAM role that was created within the *production* account. For example, the following permissions policy must be added to the IAM user or role.

```json
// [Development Account] IAM Role (or user) permissions policy
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::production-account:role/ProductionAccountRole"
  }
}
```

Once the policies have been established, a user from the *development* account can assume the production role, using the following `aws sts assume-role` command:

```shell
aws sts assume-role \
  --role-arn "arn:aws:iam::production-account:role/ProductionAccountRole" \
  --role-session-name production-account-role-name
```

#### AWS Service Role for an EC2 Instance

*AWS service role for an EC2* is an IAM role that can be attached to multiple Amazon EC2 instances, which allows your applications to securely make API requests from your instances without the need to manage the security credentials that applications use.

For example, imagine an EC2 instance needs to post a message to SQS. Rather than having to manage user access keys, a role can be attached to the EC2 instance with the required permissions to access SQS, which in turn allows the EC2 instance to assume the role and perform the actions with temporary credentials.

### Access Management with Policies and Permissions

Access to AWS resources is managed through JSON *policy* documents, which are attached to IAM identities or AWS resources.

AWS evaluates policies during API requests,using the following criteria:

- All requests are denied by default because they follow the principle of least privilege.
- If your policy has an explicit allow directive, it will override the default.
- Permissions boundaries, service control policies, and session policies can override the permissions defined in policy documents.
- If you place an explicit deny on your policy, it will override any allow directive present in the document.

#### JSON Policy Documents

The JSON policy document consists of the following elements:

- **Version:** this is the version of the policy language (latest version is 2012-10-17).
- **Statement:**
  - **Sid (Optional):** a identifier to differentiate states (can be used like a descriptor or label).
  - **Effect:** specifies whether the policy *allows* or *denies* something.
  - **Principal:** defines the principal that is affected by that statement (only used for resource-based policies, in identity-based policies the principal is implicit)
  - **Action:** a list of methods that the policy *allows* or *denies*
  - **Resource:** specifies which resources the policy is applicable to (only used for identity-based policies)
  - **Condition (Optional):** allows for custom logic to be used to test values of specific keys in the context of the request, for example whether MFA is enabled via `aws:MultiFactorAuthPresent`.

***Note**: The AWS Certified Security Speciality exam requires you to understand the JSON syntax and the policy document structure.*

#### Identity-Based Policies

Identity-based policies are JSON permissions policies that you can attach to an identity such as IAM users, IAM groups, or IAM roles, and define the actions that the principal can perform. These can be categorised into three different types:

- **AWS-Managed Policies** are provided and managed by AWS that cover the most common use cases, such as `AmazonS3ReadOnly` or `AmazonSQSFullAccess` - these policies may change based on AWS's discretion.
- **Customer-Managed Policies** are policies that are created and managed by you within your account. These policies can be attached multiple entities (user, role or group).
- **Inline Policies** are policies that are directly embedded into the entity (user, role or group) and will live within the entity - inline policies cannot be shared.

#### Resource-Based Policies

A resource-based policy allows you to directly attach permissions to AWS resources, such as an Amazon SQS queue or an Amazon S3 bucket. It also allows you to specify who has access to that resource even if it does not have an explicit identity-based policy that says so.

![Resource Based Policy](./resource-based-policy.png)

The image above shows that the user John, does not have access to the S3 bucket via an identity policy, but does have access via the S3 resource policy, which will allow the `GetObject` request to complete successfully.

#### Defining Permissions Boundaries

*Permissions boundaries* allow you to define the maximum permissions a user or application can be granted by <u>IAM identity-based policies.</u> You can use a customer-managed or an AWS-managed policy to set the permissions boundaries for an IAM user or role.

Permission boundaries do not add permissions, but define the limits of the permissions attached to them, for example, a user could be granted an administrator policy (see below).

```json
// Administrator user policy
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```

The user can have their administrator policy limited, by applying a permissions boundary. The example below, will limit the user to S3 operations only (event though they have an administrator policy attached)

```json
// Permissions boundary, restricting to Amazon S3 operations only
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow-Amazon-S3-Access-Only",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
    }
  ]
}
```

When using permission boundaries, the resulting permission set that is allowed is known as *effective permissions*. IN the example above, the effective permissions would be S3 access, even though the administrator policy was applied.



## Access Management in Amazon S3

Amazon S3 offers a specific set of resource-based policies that allows even finder-grained control over your Amazon S3 environment. Such resource-based policies are divided into two types:

- **Access Control Lists (ACLs)** are lists of grants and users who have permission for then. It's possible to define cross-account read/write permissions using ACLs, which are defined using an Amazon S3-Specific XML Schema. AWS generally recommends that you leverage IAM policies rather than ACLs.
- **Bucket Policy** provide you with a simple way to define cross-account access to your S3 buckets without setting up IAM roles. Policies are defined using JSON, and can be managed per user-level or per account level. Policies are applied at the bucket level - they do not extend to object-level granularity.

### Policy Conflicts

When Amazon S3 needs to authorize a request to a bucket or object, it evaluates all access policies, such as user policies and resource-based policies (bucket policy, bucket ACL, and object ACL) associated with the respective target of the request.

The following steps are followed by Amazon S3 when evaluating policy conflicts:

1. Every bucket and object is private by default (principle of least privilege).
2. Access policies, user policies and resource-based policies (bucket policy, bucket and object ACLs) are all evaluated
3. If an explicit *deny* is found, evaluation stops and the request is denied.
4. If an explicit *allow* is found, evaluation stops and the request is allowed. 
5. In any other case, the request is denied.

***Note:** when dealing with policy conflicts on Amazon S3, the AWS Cloud follows the principle of least privilege where everything is denied by default, unless instructed otherwise by an allow. An explicit deny will always override any other allow policy statement.*

### Secure Data Transportation in Amazon S3

Amazon S3 supports HTTP and HTTPs requests by default, but to guarantee that all data is encrypted in transit, you must block all  non-secure transit requests using a bucket policy (as shown below).

```json
// Enforce HTTPs (TLS) Bucket Policy
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowRequests",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::your-s3-bucket/*"
    },
    {
      "Sid": "ForceSSLRequests",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::your-s3-bucket/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
```

In the example above, the policy's first statement allows all requests to the bucket, but the second statement blocks all requests that do not match the `"aws:SecureTransport": "false"`.

### Cross-Region Replication in Amazon S3

*Cross-region replication (CRR)* replicates objects from one region to another in an asynchronous fashion. Such replication can happen between buckets owned by the same AWS account or by different accounts. 

Replication only happens in a one-to-one relation, or simply, from one source to one destination. Once the object is replicated, it is not possible to replicate it again. When CRR is enabled, data replicated is performed using SSL encryption by default - you do not need to write a policy to enforce this.

When CRR is enabled, the following items <u>are replicated:</u>

- New objects created after the replication is activated. Old objects will not be replicated unless they are changed after the replication was activated.
- Unencrypted objects.
- Encrypted objects by SSE-S3-managed keys or customer-managed keys (CMKs) stored in Amazon KMS (SSE-KMS). The latter should be explicitly enabled to work.
- Object metadata, ACL updates, any existing tags, and lock retention information.
- If you perform a `delete` operation to mark the object as deleted, this marker will be replicated.

The following items represent what <u>is not replicated</u> by the CRR:

- Objects created before the CRR was enabled.
- Any objects created with SSE-C, or customer-provided encryption keys.
- Objects deleted through a delete operation with a version ID specified. This prevents malicious deletion of your data.

For cross-region replication to work, you should pay attention to key requirements such as the following:

- Versioning should be enabled in both buckets (source and destination).
- Make sure that the replication role specified gives all the necessary permissions to replicate and access the objects on the source bucket.
- If the destination bucket is owned by a different AWS account, the account owner of the destination must grant the required permission to store the replicated objects. It is also possible to change object ownership during replication to the destination bucket.
- If the owner of the source bucket does not have permissions on the stored objects, the `read` and `read_acp` permissions should be granted; otherwise, replication of these objects will fail.
- Bucket owner must have permissions to access objects (ACLs) to perform the replication.

### Amazon S3 Pre-signed URLs

*Pre-signed* URLs allow users and applications to access private objects for a limited period of time. Anyone who has access to a pre-signed URL will have access to the object.

To create pre-signed URLs, you must provide security credentials (e.g. access keys), the bucket name, and the object key that you want to share. By default the expiration time is 1 hour (3600 seconds), but this can be extended up to 7 days.

The example below command below uses the `presign` command to share the `hello.txt` file in the `security-bucket-example-0009` bucket.

```shell
> aws s3 presign s3://security-bucket-example-0009/hello.txt
https://security-bucket-example-009/hello.txt?AWSAccessKeyId=EXAMPLE-ACCESS-KEY&Signature=EXHCcBe%EXAMPLEKnz3r8O0AgEXAMPLE&Expires=1555531131
```

***Note**: the permissions defined by the pre-signed URL are scoped at the object level and do not allow any other operations at the bucket level.*



## Identity Federation

### Amazon Cognito



## Multi-Account Management with AWS Organisations

### Service Control Policies

### AWS Single Sign-On



## Microsoft AD Federation with AWS 



## Protection Credentials with AWS Secrets Manager

### Secrets Permission Management

### Automatic Secrets Rotation

### AWS Secrets Manager vs AWS Systems Manager Parameter Store