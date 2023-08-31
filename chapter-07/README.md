# Incident Response

*Incidents* are defined as a violation (or a threat of violation) of security policies, acceptable usage policies, or standard security practices. Incidents may be as harmful as a DDoS attack, or as mundane as an incorrect firewall configuration.

Incident responses can be *manual* or *automated*, for example you may receive a notification when a configuration has been altered and manually decide if it needs to be reverted. Alternatively, you could establish an AWS Config rule that receives the changed notification, compares it with the desired state, and takes immediate action to correct the misstep.

The set of actions - either *manual* or *automated* - are known as an *incident response plan*.

## Incident Response Maturity Model

Incident response is a comprehensive and wide-scoped topic that tries to provide a reduction to risks. The process may also involve external parties in addition to the internal organisation, such as law security research organisations, and forensics specialists.

The three components of an incident response plan are outlined below:

- **incident management** or how it can improve over time
- **constituent factors** such as people, technology, and processes
- **incident life cycle** detect, isolate, contain, remediate, recover, and forensics

![incident-response-maturity-model](./incident-response-maturity-model.png)

An incident response plan is inherently a process, and it is subject to a continuous improvement cycle. It leverages the security wheel practical model (which was outlined in [Chapter 1](../chapter-01#the-security-wheel)) which comprises of the following actions: develop a security policy; implement security mechanisms; monitor and test the response to the incident; and manage and update the process accordingly.

In the maturity model presented above:

- **Within the develop phase** you will need to gather as much information about your protected resources as you can and define your goals, outcomes and any training that is required for the people involved. You should also assess any gap between the current and the desired levels.
- **Within the Implement Phase** you should carry out the actions and use tools to close the aforementioned gap. An important portion of this phase focuses on increasing incident visibility (such as using incident notifications) for the responsible personnel.
- **Within the monitor & test phase** you will put your security incident response plan into action either using a proactive or reactive approach. During the event, you should document and measure your capabilities to response.
- Within the update phase you will want to identify opportunities of improvement, and apply those improvements to your security response process

*Incident response actions* are performed by the constituent factors: people, technology, and processes.

- **People** refers to the human resources, both internal (such as IT information security departments, legal, compliance) and external to your organisation (such as authorities, security research organisations and forensics specialists) that are involved in an incident response.
- **Technology** refers to the technical tools to use in an incident response, examples within AWS Cloud are identity and access management, detective controls, and infrastructure and data protection.
- **Process** refers to a human-triggered or automated predefined sequence of actions to respond to a security incident. Automation can reduce the response times for suspicious activities to correct misconfigurations before any malicious actor can exploit them

The evolution of an incident is known as the *incident life cycle*. First you would *detect* the suspicious activity, and confirm what the impact is for the incident. Next you must *isolate* the affected resources, and *contain* the spreading to other resources. Corrective controls should be applied to *remediate* the affected resources, and once your environment has been recovered, your must confirm that it is performing as expected. 

Finally, you will execute a *forensics* analytical process to identify the root causes of the security incident and understand how it behaved along its whole life cycle. This outcome for this phase is critical for the continuous improvement cycle. 



## Incident Response Best Practices

### Develop

### Implement

### Monitor and Test

### Update



## Reacting to Specific Security Incidents

### Abuse Notifications

### Insider Threat and Former Employee Access

### Amazon EC2 Instance Compromised by Malware

### Credentials Leaked

### Application Attacks
