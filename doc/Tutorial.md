# Tutorial

This tutorial explains how to use the framework by building a sample Bank Account application. The tutorial will guide you through defining the key classes and implementing the necessary components.

## Defining Key Classes

To develop an application using the framework, you need to define three main types of classes:

1. **Model**: Represents the core data structure of your application.
2. **Event**: Represents changes or mutations to the model.
3. **ModelSpace (Aggregation)**: Manages the lifecycle and state of models, including snapshots and event replay.

### Defining the Model Class

The `Model` class represents the main data structure of your application. In this example, we define a `HsBankAccount` model to represent a bank account.

```Smalltalk
HsModel << #HsBankAccount
    slots: { #name . #emailAddress . #balance };
    package: 'Historia-Examples-Bank'
```

- `HsModel` is an abstract class provided by the framework for defining models.
- The `slots` define the attributes of the model. Here, we define `name`, `emailAddress`, and `balance` as the attributes of the bank account.

### Defining the Event Class

All changes to the model are performed through events. Each type of mutation requires a corresponding event class. For example, to handle changes to the bank account balance, we define an event class:

```Smalltalk
HsValueChanged << #HsBankAccountBalanceChanged
    slots: {};
    package: 'Historia-Examples-Bank'
```

- `HsValueChanged` is a base class for events that represent changes to a model's values.
- The `slots` can be used to define additional data required for the event. In this case, no additional data is needed.

### Defining the ModelSpace (Aggregation)

The `ModelSpace` class is responsible for managing the lifecycle of models, including saving snapshots and replaying events. Here, we define a `HsBankAccountSpace` to manage `HsBankAccount` models.

```Smalltalk
HsModelSpace << #HsBankAccountSpace
    slots: {};
    package: 'Historia-Examples-Bank'
```

- `HsModelSpace` is a base class for managing models.
- The `slots` can be used to define additional attributes or dependencies for the `ModelSpace`.

### Summary of Key Classes

- **Model**: Represents the structure of your data (e.g., `HsBankAccount`).
- **Event**: Represents changes to the model (e.g., `HsBankAccountBalanceChanged`).
- **ModelSpace**: Manages the state and lifecycle of models (e.g., `HsBankAccountSpace`).

## Implementing Mutations

Once the key classes are defined, the next step is to implement mutations. Mutations are the actions that modify the state of the model. These are performed by creating and applying events.
