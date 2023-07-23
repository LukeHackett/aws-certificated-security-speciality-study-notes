# Detective Controls

An important part of the security cycle is being able to understand what is actually happening in an environment.

Observing when systems fail or perform an undesired action is an important part of an organisation's security posture. In order to infer what is happening with a system, you will need to monitor the system's generated events. This practise is known as *observability*.

All *resources* within an AWS account are observable objects that are continuously changing based upon information they manage (extract, process, store, transmit, analyse, generate, or archive)

Gathering information about the status of your resources and, most importantly, the events they produce is important. These events represent how the resources are changing and how they are interacting with external elements and also among themselves.

To explain the various detective controls, this chapter will follow the *Detective controls flow framework*, outlined below.

![Detective Control Framework](./detective-control-framework.png)

The framework is split into four main stages: resources state, events collection, events analysis, and action.

The flow starts with a collection of resources (i.e. the *objects* under observation) and the act of keeping track of its configuration and status over time. A resource can be an AWS resource (i.e. EC2 Instances, API Gateways), external resources (i.e SaaS or custom applications), or AWS Cloud services themselves (i.e. a service reporting the API calls it receives). This resource collection is the first stage, the *resources state*.

Resources will change over time (i.e. due to changes in business requirements, regulatory requirements etc), and such changes or and actions in the environment is referred to as an *event*. Events can occur at any time, and should be recorded as an *observable record*. The second stage, *events collection*, handles the string of events occurring in the environment. Record creation can be either *passive* or *active*. A record is *passively* created when external sources are responsible for sending event notification to the detective control, whereas a record that is *actively* created is on that was created by detective service intentionally looking for information.

Once events have been captured the third stage, *events analysis*, performs analysis upon the records to produce value-added information. The analysis can be perform in several ways, such as comparing the event with a baseline figure; or comparing the event to statistics to determine whether the event is normal, or even leveraging machine learning techniques to identity suspicious operations. 

At this stage, the service can also have a *passive* or *active* posture. A *passive* posture characterises an analysis based on the received observable records, while an *active* posture intentionally gathers additional information from the monitored resources. 

The final result of *events analysis* stage is a repository of observable records, but like in the *events collection* stage, they are a direct
result of an analytical process.

In the *action stage*, it is possible to connect the detection controls with reactive actions, through the use of automation in the cloud. Amazon EventBridge is arguably one of the most powerful tools in the *action stage*, as it is able to connect the source of events with consumers who can respond to those events.



## Stage 1: Resources State

The first stage in the detective framework focuses on knowing the state of the monitored resources. AWS provides tools that assess the current situation of resources at different levels and keep historical track of their state.

### AWS Config

### AWS Systems Manager



## Stage 2: Events Collection

### AWS CloudTrail

### Amazon CloudWatch Logs

### Amazon CloudWatch

### AWS Health



## Stage 3: Events Analysis

### AWS Config Rules

### Amazon Inspector

### Amazon GuardDuty

### AWS Security Hub

### AWS Systems Manager: State Manager, Patch Manager, and Compliance

### AWS Trusted Advisor





## Stage 4: Action

### AWS Systems Manager: Automation

### AWS Config Rules: Remediation

### Amazon EventBridge
