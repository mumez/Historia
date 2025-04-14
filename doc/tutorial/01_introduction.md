# Introduction

Let's now explain how to use the framework by building a sample bank account application. This tutorial will walk you step-by-step through the definition of the main classes and the implementation of the required components.

## Defining Key Classes

To develop an application using the framework, you need to define three main types of classes:

1. **Model**: Represents the core data structure of your application.
2. **Event**: Represents mutations to the model.
3. **ModelSpace (Aggregation)**: Manages the lifecycle and state of models, including snapshots and event replay.

### Class Definitions for Bank Account Application

In the bank account application, we will define the following classes:

- **Model**: `HtBankAccount` represents the bank account model.
- **Event**: `HtBankAccountBalanceChanged` represents changes to the bank account balance.
- **ModelSpace**: `HtBankAccountSpace` manages multiple bank accounts and their lifecycles.
