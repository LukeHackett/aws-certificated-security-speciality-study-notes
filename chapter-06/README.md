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



## AWS Certificate Manager



## Protecting S3 Buckets



## Amazon Macie