# Data Protection

Using a variety of AWS cloud security controls, services, and practices, a security team aims to create the mechanisms and implement the necessary controls to protect sensitive data stored in the AWS Cloud, thus meeting regulatory, security, and data privacy needs.

With the emergence of data privacy and protection regulations around the world (e.g. GDPR), data protection and privacy are becoming even more strategic topics for all kinds of business and governmental organisations.

## Encryption and Hashing

*Cryptography* is defined as the ability to transform standard text information into ciphertext using cryptographic algorithms and keys.

The use of encryption is essential to increasing the level of data protection, but encryption should be seen as a layer of defence and not the only defence.

When deploying encryption, you have two types of cryptographic algorithms you can implement, symmetric and asymmetric.

### Symmetric Encryption

Keys are strings of data that are used to encrypt and decrypt other data, specifically *symmetric encryption* algorithms, will use the same key for both operations.

![symmetric-encryption](./symmetric-encryption.png)

The size of such keys determines how hard it is for an attacker to try all possible key combinations when attempting to decrypt an encrypted message.

AWS cryptographic tools and services support two widely used symmetric algorithms: 

- **Advanced Encryption Standard (AES)** with 128, 192, or 256-bit keys.
- **Triple DES (3DES)** which uses three 56-bit keys, working on a block of data and applying arbitrary round functions derived from an initial function.

### Asymmetric Encryption

*Asymmetric Encryption* uses two distinct keys (one public and one private) that are both mathematically derived. Asymmetric Encryption can be used to guarantee confidentially as well as authenticity (or non-repudiation).

AWS services typically support Rivest–Shamir–Adleman (RSA) for asymmetric cryptographic key algorithms. RSA uses key sizes of 1024, 2048, and 3072 bits.

#### How to Guarantee Confidentially

If Alice wants to send some data to Bob, Alice would need to encrypt the data using Bob's public key, and Bob would decrypt the data using his private key. 

Likewise, if Bob wanted to send data back to Alice, he would need to encrypt the data using Alice's public key, and Alice would decrypt using her private key.

*Note:* the private keys must be adequately protected against any improper access in order for this to be secure.

#### How to ensure Authenticity 

When private keys are used to digitally sign a message, it assures the receiver that only the owner of the private key could sign it correctly. 

The destination that receives the message can validate whether the message came from the expected source, using the public key.

![asymmetric-encryption](./asymmetric-encryption.png)

### Hashing

Hashing is a feature that applies a *hashing algorithm* to a piece of information generating a message digest. Different input sizes generate different digest output, but the digest length will always be the same.

A good hashing algorithm is irreversible, hut as hashed values are smaller than the original data, duplicate hashed values can be generated, which are known as *collisions*.

Collisions can be avoided by using larger hash values, or they can be resolved with multiple hash functions, overflow tables, or salts.



## AWS Key Management Service

The *AWS Key Management Service (KMS)* allows you to natively encrypt data in a seamless and integrated manner with many AWS services, such as Amazon RDS, Amazon DynamoDB, Amazon Redshift, Amazon EMR, Amazon S3 and Amazon EBS. KMS supports an end-to-end encryption strategy, enabling the encryption of data stored on servers (EBS), objects stored on Amazon S3 and on various databases.

![end-to-end-encryption](./end-to-end-encryption.png)

The diagram above highlights where the AWS KMS service can be used to encrypt data across the three most common application layers.

AWS KMS uses dedicated hardware security modules to generate keys, and will manage these instances for you. A dedicated HSM can be created, when regulatory and security policies require such a function via the Amazon CloudHSM deployment.



### AWS KMS Components

The AWS KMS service contains a number of components that allow for data to be easily encrypted and decrypted.

#### Master and Data Key

One of the biggest challenges when you are implementing symmetric key encryption models is the protection of the keys. While is it possible to encrypt a key with another key, you still have to find a way of storing the last key securely. The last key requires the highest level of protection and is commonly known as the *master key*.

![master-data-keys](./master-data-keys.png)

Due to the nature of key protection, AWS KMS creates the environment to manage and protect your master keys. The AWS KMS service never exposes your master key in clear text, outside of the protected boundary. The master key is used to encrypt and protect your data key, and the data key is used to encrypt and decrypt your data in many different services.

![master-key-protection](./master-key-protection.png)

Access to the master key can only be achieved via the AWS Console, CLI or SDKs, and thus new keys can be created in a secure manner (see diagram below). The master keys are protected by Federal Information Processing Standard (FIPS) 140-2 validated cryptographic modules.

![accessing-master-key](./accessing-master-key.png)


#### Customer Master Keys

A customer master key (CMK) is a 256-bit AES for symmetric keys that has a unique key ID, alias, and ARN (Amazon Resource Name) and is created based on a user-initiated request through AWS KMS. 

A CMK resides at the top of your key hierarchy, and is not exportable - it can only reside within AWS KMS. A CMK can be used to integrate multiple data keys, to protect data in an integrated manner with other AWS services.

![kms-service-integration](./kms-service-integration.png)

##### Attributes

Customer master keys have three additional attributes that can be used for identification:

- **KeyID** is a unique key identifier that does not change until the key is rotated
- **Alias** is a user-friendly name that can be associated with a CMK, that can be referenced by applications and services and will alway refer to that key, regardless of if the key has been rotated
- **ARN** the Amazon Resource Name for the key

##### Permissions

The *permissions* define the principals that are allowed to use the keys for encryption and decryption, and also the account(s) that can administer and add IAM policies to the key.

Each CMK must have at least two policies roles defined:

- **Key Administrators** IAM users or roles that can manage the keys
- **Key Users** IAM Users or roles that can use the keys to encrypt or decrypt data

![cmk-permissions](./cmk-permissions.png)

*Note: the AWS Root account will be able to perform all actions upon a CMK, regardless of the policies that have been assigned to the CMK.*



### Managing Customer Master Keys

Within the AWS KMS service there are three categories of keys:

- **AWS managed keys** are the default master keys that protects S3 objects, Lambda functions and Workspaces when no other keys are defined for these services.
- **Customer-managed keys** are CMKs that the users can create an administer using JSON policies
- **Custom key stores** are used when you want to manage your CMKs using a dedicated AWS CloudHSM cluster, giving you direct control to the HSMs that generate and manage the key material for your CMKs

#### Creating Keys

Creating a new key can be completed via the AWS Console, CLI or SDK. 

You will need to provide the following details:

- **Key Type** either symmetric or asymmetric
- **Origin** should be one of KMS, External Key Store or CloudHSM Store
- **Regionality** either single-region or multi-region (with the latter replicating into multiple AWS Regions)
- **Alias** the alias of the key
- **Key Administrators** IAM users or roles that can manage the keys
- **Key Users** IAM Users or roles that can use the keys to encrypt or decrypt data
- **Key Deletion** whether to allow administrators of the key to delete it (if not selected, only the root user can delete the key)

#### Deleting Keys

When you delete a CMK you will not be able to decrypt data that was encrypted with that CMK any more - i.e. the encrypted data becomes unrecoverable.

AWS KMS enforces a minimum of 7 days and a maximum of 30 days (default configuration) as a waiting period for deleting a CMK. If you are in doubt, it is possible to disable the CMK and enable it again later if necessary.

When a CMK is set to pending deletion or disabled, the CMK cannot be used, nor rotated. Additionally AWS KMS does not rotate other derived keys from a pending deletion or disabled CMK.

#### Rotating Keys

You can use the AWS Console or CLI to enable and disable automatic key rotation, as well as view the rotation status of any CMK. When you enable automatic key rotation, AWS KMS automatically and transparently rotates the CMK every 365 days after the enable date.

When an S3 bucket is using KMS keys to protect data, KMS manages the entire rotation process, keeping the previous cryptographic material used to generated data encryption keys. After rotating a CMK, new objects will be encrypted using the new key, while older objects will be decrypted using the older keys.

Manual key rotation may be needed because of rotation schedule or if you have brought your own keys into KMS.

### Protecting RDS with KMS

- You can only enable encryption for an Amazon RDS database instance when you create it, not after it is created. 
- You cannot have an encrypted read replica of an unencrypted database instance or an unencrypted read replica of an encrypted database instance. 
- You cannot restore a backup or unencrypted snapshot to an encrypted database instance. 
- Encrypted read replicas must be encrypted with the same key as the source database instance. 
- If you copy an encrypted snapshot within the same AWS region, you can encrypt the copy with the same KMS encryption key as the original snapshot, or you can specify a different KMS encryption key. 
- If you copy an encrypted snapshot between regions, you cannot use the same KMS encryption key for the copy used for the source snapshot because the KMS keys are region specific. Instead, you must specify a valid KMS key in the target AWS region.

### Protecting EBS with KMS

- Encryption by default is a region-specific setting. If you enable it for a region, you cannot disable it for individual snapshots or volumes in that region.
- By enabling encryption by default, you can run an Amazon EC2 instance only if the instance type supports EBS encryption.
- EBS volumes are encrypted by your account’s default client master key unless you specify a customer-managed CMK in EC2 settings or on execution
- Encryption by default does not affect existing EBS snapshots or volumes, but when copying encrypted snapshots or restoring unencrypted volumes, the resulting volumes or snapshots are encrypted
- Without encryption by default enabled, a restored volume of an unencrypted snapshot is unencrypted by default.
- When the CreateVolume action operates on an encrypted snapshot, you have the option of encrypting it again with a different CMK. 
- The ability to encrypt a snapshot while copying lets you apply a new CMK to an already encrypted snapshot belonging to you. Restored volumes from the resulting copy are only accessible using the new CMK



## Understanding the Cloud Hardware Security Module

A hardware security module (HSM) is a hardware-based encryption device. 

AWS CloudHSM is a managed service that automates administration tasks such as hardware provisioning, software patching, high availability configurations, and key backups. AWS CloudHSM lets you scale quickly by adding or removing on-demand HSM capabilities, in a pay-as-you-go model.

Generally, the use of an HSM Cloud is directly related to meeting regulatory needs, such as FIPS 140-2 Level 3 standards. To create an HSM cluster in the AWS Console, you must configure the VPC, subnets, and their availability zones where cluster members will be provisioned

Once you have created a cluster, you need to kickstart it by validating the HSM certificate chains, verifying the identity of your cluster, and then importing the signed cluster certificate and your issuing certificate. The diagram below illustrates the CloudHSM certificate hierarchy.

![cloudhsm-certificate-hierarchy](./cloudhsm-certificate-hierarchy.png)

Each of the certificates are outlined below:

- **AWS Root Certificate:** This is AWS CloudHSM’s root certificate. 
- **Manufacturer Root Certificate:** This is the hardware manufacturer’s root certificate. 
- **AWS Hardware Certificate:** AWS CloudHSM created this certificate when the HSM hardware was added to the fleet. This certificate asserts that AWS CloudHSM owns the hardware. 
- **Manufacturer Hardware Certificate:** The HSM hardware manufacturer created this certificate when it manufactured the HSM hardware. This certificate asserts that the manufacturer created the hardware. 
- **HSM Certificate:** The HSM certificate is generated by the FIPS-validated hardware when you create the first HSM in the cluster. This certificate asserts that the HSM hardware created the HSM. 
- **Cluster CSR (certified signing request):** The first HSM creates the cluster CSR. When you sign the cluster CSR, you claim the cluster. Then, you can use the signed CSR to initialize the cluster.

Once the Cluster HSM (a collection of individual HSMs) is configured, the client can access the service through network interfaces and security group configurations directly from their VPC.

![clusterhsm-architecture](./clusterhsm-architecture.png)

*Note: Applications in the Customer VPC must use an ENI to access CloudHMS and keys provisioned in the service VPC.*

### Using CloudHSM with AWS KMS

AWS CloudHSM can integrate with the AWS KMS service, allowing for the CloudHSM cluster to protect the customer master keys (CMKs) and thus the data keys and data in the most diverse AWS cloud services.

When you are using your own key store using AWS CloudHSMs that you control, KMS generates and stores the Key material for the CMK inside the CloudHSM cluster that you own and manage -i.e. the cryptographic operations under that Key are performed by your CloudHSM cluster.

The main scenarios in which you'd want to use your own CloudHSM are:

- You have keys that are required to be protected in a single-tenant HSM or in an HSM over which you have direct control
- You must store keys using an HSM validated at FIPS 140-2 Level 3 overall (the HSMs used in the default KMS key store are validated to Level 2).
- You have keys that are required to be auditable independently of KMS

### SSL Offload Using CloudHSM

You can use AWS CloudHSM to offload SSL encryption and decryption of traffic to your servers or instances, improving private key protection, reducing performance impact into your application, and raising your application security when using AWS Cloud.



## AWS Certificate Manager

AWS Certificate Manager (ACM) is a managed service that allows you to quickly provision, manage, and deploy Secure Sockets Layer (SSL)/Transport Layer Security (TLS) certificates for use with both AWS Cloud–native services and your internal resources.

The AWS Certificate Manager service allows for SSL certificates to be requested and deployed into ACM-integrated AWS services such as Elastic Load Balancers, Amazon CloudFront distributions, and Amazon API Gateway. Moreover, the AWS Certificate Manager will administer the renewals of these certificates

The service can also be used for internal digital certificate generation, functioning as an internal CA (certificate authority). 

ACM has no costs when used within the AWS-native environment and resources. However, when using it as an internal certificate authority for on-premises environments, it has a monthly cost



## Protecting S3 Buckets

Since any type of data can be stored in S3, it is crucial to apply the necessary security measures to protect sensitive information that may have been stored in S3.

### Default Access Control Protection

Every bucket in S3 is created by default as a private bucket - i.e. no public external access. 

Even so, when a bucket is created as private, its configuration can be changed by a user if they have predefined access to do so, which could mistakenly make the bucket public, due to an operational or automation process error

### Bucket and Object Encryption

When created with the default settings, buckets are automatically defined as private.  Additionally, Amazon S3 now applies server-side encryption with Amazon S3 managed keys (SSE-S3) as the base level of encryption for every bucket in Amazon S3 (only for buckets created after January 2023).

Amazon S3 supports the following encryption configurations:

- **SSE-S3:** Server-side encryption with Amazon S3–managed keys 
- **SSE-KMS:** Server-side encryption with KMS customer-managed master keys 
- **SSE-C:** Server-side encryption with customer-provided encryption keys

#### SSE-S3 Encryption

SSE-S3 is the native encryption functionality of the AWS S3 service, and provides the required functionality to natively encrypt objects inserted into a bucket using an AES-256 symmetric key, which is automatically generated and managed directly by the S3 service, at no additional cost.

#### SSE-KMS Encryption

SSE-KMS is the encryption functionality of the S3 service that uses encryption keys managed with KMS. This functionality sets the behaviour of S3 to encrypt by default every object inserted into the specified bucket using keys managed through KMS, regardless of whether they are AWS managed keys or customer-managed keys. 

Objects inserted in the bucket after this configuration is performed will be encrypted even if no encryption option is specified in the request

It is also important to know that an extra cost might incur in this configuration, as additional requests are being made to the AWS KMS service.

#### SSE-C Encryption

Using SSE-C, you can set your own encryption keys, which you must provide as part of a request. Amazon S3 manages encryption and decryption when storing and accessing objects using the customer key provided.

The customer is in charge of managing the keys provided in each request, and only the data is encrypted and not the object’s metadata. When you upload an object, Amazon S3 uses the provided encryption key to apply AES256 encryption to the data and deletes the encryption key from memory, thus not storing the encryption key you provided.

*Note: If the customer loses the encryption key, the stored object data is also lost.*

#### SSE-KMS Encrypted Objects Replication

By default, Amazon S3 doesn’t replicate objects that are stored using SSE-KMS. You must modify the bucket replication configuration to tell Amazon S3 to replicate these objects using the right KMS keys.

You must select the right CMK used to decrypt the objects in the source bucket, and then define the destination bucket with the destination key to encrypt the objects



## Amazon Macie

Amazon Macie is a security service that uses machine learning and artificial intelligence (ML/ AI) technology to discover, classify, and protect sensitive data in the AWS Cloud. 

Amazon Macie will search S3 buckets to create an inventory of sensitive data, personally identifiable information (PII), or intellectual property while providing dashboards and alerts that show suspicious access and unusual data-related activity.

Additionally Amazon Macie will use CloudTrail Events to identify bad behaviours and to generate alerts.

![macie-dashboard](./macie-dashboard.png)

The diagram above shows the S3 data inventory classification, and in the top-right corner, the alerts classification per user category. Macie categorizes the alerts based on four different categories: platinum, gold, silver, and bronze.

- **Platinum:** IAM users or roles that have a history of making high-risk API calls indicative of an administrator or root user. These accounts should be monitored closely for signs of account compromise. 
- **Gold:** IAM users or roles that have a history of making infrastructure-related API calls indicative of a power user, such as running instances or writing data to Amazon S3. 
- **Silver:** IAM users or roles that have a history of issuing high numbers of medium-risk API calls, such as Describe* and List* operations, or read-only access requests to Amazon S3. 
- **Bronze:** IAM users or roles that typically execute lower numbers of Describe* and List* API calls in the AWS environment.


### AWS CloudTrail Events

Amazon Macie uses CloudTrail Events as a data source for monitoring and learning of possible anomalous behaviors in an AWS customer environment, assigning a risk level between 1 and 10 for each of CloudTrail’s supported events.