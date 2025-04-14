# Historia Framework Tutorial

This tutorial explains how to use the Historia framework by building a sample Bank Account application. The tutorial is divided into 12 chapters, each focusing on a specific aspect of the framework.

## Chapter Overview

### 1. [Introduction](01_introduction.md)

Introduces the framework and explains the three main types of classes needed to develop an application:

- Model: Represents the core data structure
- Event: Represents changes to the model
- ModelSpace: Manages the lifecycle and state of models

### 2. [Model Implementation](02_model_implementation.md)

Shows how to define a model class (`HtBankAccount`) with its attributes and initializer. Explains the use of slots for defining model attributes and the importance of proper initialization.

### 3. [Event Implementation](03_event_implementation.md)

Demonstrates how to create event classes (`HtBankAccountBalanceChanged`) to represent changes to the model. Covers event registration and the role of events in tracking model changes.

### 4. [ModelSpace Implementation](04_modelspace_implementation.md)

Explains how to create a ModelSpace (`HtBankAccountSpace`) to manage models. Describes the key functionalities of ModelSpace including aggregation, lifecycle management, and event replay.

### 5. [Mutations](05_mutations.md)

Details the process of implementing mutations in the framework. Shows how to:

- Define mutation methods in the model
- Create event application methods
- Update model state through events

### 6. [ModelSpace Registration](06_modelspace_registration.md)

Explains how to register models to a ModelSpace. Covers:

- Creating a ModelSpace instance
- Registering models with unique IDs
- Event-driven registration process

### 7. [Domain Actions](07_domain_actions.md)

Shows how to implement domain-specific actions in the ModelSpace. Includes:

- Balance retrieval
- Deposit operations
- Withdrawal operations
- Error handling considerations

### 8. [Event Retrieval](08_event_retrieval.md)

Explains how to retrieve and manage events in the framework. Covers:

- Accessing all events
- Retrieving recent event versions
- Managing large numbers of events

### 9. [Snapshots](09_snapshots.md)

Describes how to use snapshots for efficient state management. Includes:

- Saving snapshots
- Loading snapshots
- Managing snapshot versions

### 10. [Event Replay](10_event_replay.md)

Shows how to restore ModelSpace state through event replay. Covers:

- Creating new ModelSpace instances
- Using catchup for synchronization
- Automatic state updates

### 11. [Time Traveling](11_time_traveling.md)

Explains how to explore past states of the ModelSpace. Includes:

- Retrieving event versions
- Using the goTo: method
- Differential replay optimization

### 12. [EventBridge Collaboration](12_eventbridge_collaboration.md)

Demonstrates how to use EventBridge for communication between ModelSpaces. Covers:

- Creating custom bridges
- Handling notification events
- Implementing transfer functionality
- Auditing mutation events

## Getting Started

To get started with the tutorial:

1. Begin with the Introduction chapter to understand the basic concepts
2. Follow the chapters in order to build the Bank Account application
3. Each chapter builds upon the previous ones, so it's recommended to complete them sequentially

## Prerequisites

- Basic understanding of Smalltalk programming
- Familiarity with object-oriented programming concepts
- Access to a Smalltalk environment with the Historia framework installed
