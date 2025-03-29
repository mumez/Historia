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

Please add plain accessor(getter/setter) methods for `name`, `emailAddress`. For `balance`, we only need the `balance` getter, because we will add a mutation method for `balance` later.

Also add initializer:

```Smalltalk
initialize
    name := ''.
    emailAddress := '',
	balance := 0.
```

### Defining the Event Class

All changes to the model are performed through events. Each type of mutation requires a corresponding event class. For example, to handle changes to the bank account balance, we define an event class:

```Smalltalk
HsValueChanged << #HsBankAccountBalanceChanged
    slots: {};
    package: 'Historia-Examples-Bank'
```

- `HsValueChanged` is a base class for events that represent changes to a model's value.
- The `slots` can be used to define additional data required for the event. In most cases, no additional data is needed, because superclass already defines slots for holding typical event values such as context, arguments, and user-id.

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

Once the key classes are defined, the next step is to implement mutations. Mutations are the actions that modify the state of the model. These are performed by creating and applying events.

## Implementing Mutations

Mutations are the actions that modify the state of the model. In this framework, all mutations are tracked as events, ensuring that every change is recorded and can be replayed or audited later. This section explains how to implement mutations step by step.

### Step 1: Define a Mutation Method in the Model

To modify the `balance` attribute of the `HsBankAccount` model, we define a mutation method called `mutateBalanceChange:`. This method creates an event to record the change and applies it to the model.

```Smalltalk
mutateBalanceChange: newBalanceChange
    self mutate: HsBankAccountBalanceChanged using: [ :ev |
        ev value: newBalanceChange ]
```

#### Key Points:

1. **No Direct Assignment**: Unlike a typical setter method, this method does not directly assign a value to the `balance` attribute.
2. **Event Creation**: The `mutate:using:` method is used to create an event (`HsBankAccountBalanceChanged`) and record the change.
3. **Event Configuration**: The block `[ :ev | ev value: newBalanceChange ]` sets the value of the event to the new balance change.

This ensures that the mutation is recorded as an event, making it possible to track and replay changes.

---

### Step 2: Define an Apply Method in the Event Class

The next step is to define how the event should be applied to the model. This is done by implementing the `applyTo:` method in the `HsBankAccountBalanceChanged` event class.

```Smalltalk
applyTo: target
    target applyBalanceChange: self value
```

#### Explanation:

- The `applyTo:` method is called by the framework to apply the event to the target model (`HsBankAccount` in this case).
- The `self value` retrieves the value stored in the event (e.g., the balance change amount).
- The `applyBalanceChange:` method is then called on the target model to update its state.

---

### Step 3: Define the Apply Method in the Model

Finally, we define the `applyBalanceChange:` method in the `HsBankAccount` model. This method updates the `balance` attribute based on the value provided by the event.

```Smalltalk
applyBalanceChange: newBalanceChange
    balance := balance + newBalanceChange
```

#### Important Notes:

- **Framework-Only Usage**: The `applyBalanceChange:` method should only be called by the framework when replaying events. It should not be used directly in your application code, as this would bypass the event recording mechanism.
- **Historical Tracking**: By relying on events, the framework ensures that all changes to the `balance` attribute are tracked and can be audited or replayed.

---

### Summary of the Mutation Process

1. **Mutation Method**: The `mutateBalanceChange:` method in the model creates and applies an event.
2. **Event Application**: The `applyTo:` method in the event class defines how the event modifies the model.
3. **State Update**: The `applyBalanceChange:` method in the model updates the state based on the event.

---

Now you are done implementing the `balance` mutation. You can proceed to explore how to manage snapshots and replay events in the `ModelSpace` to fully utilize the framework's capabilities!

## Registering BankAccount Domain Class to ModelSpace

In this section, we will register the `HsBankAccount` domain model to the `HsBankAccountSpace`. This step is essential because the `ModelSpace` is responsible for managing the lifecycle of models, including storing, retrieving, and replaying events.

### What is a ModelSpace?

A `ModelSpace` acts as a container for managing multiple model instances. It provides the following key functionalities:

- **Aggregation**: It aggregates model instances, allowing you to manage them collectively.
- **Lifecycle Management**: It handles the creation, updating, and deletion of models.
- **Event Replay**: It can replay events to restore the state of models to a specific point in time.

Each `ModelSpace` is identified by a unique `spaceId`, which allows you to create and manage multiple independent spaces.

### Registering a Model to a ModelSpace

To register a model instance (e.g., a bank account) to a `ModelSpace`, follow these steps:

1. **Create a ModelSpace**: Use the `spaceId:` method to create a new `ModelSpace` instance.
2. **Create a Model Instance**: Instantiate the `HsBankAccount` model and set its attributes.
3. **Register the Model**: Use the `putModel:` method to add the model to the `ModelSpace`.

Here is an example:

```Smalltalk
"Step 1: Create a ModelSpace"
spaceId := 'bank-account-app-1'.
modelSpace := HsBankAccountSpace spaceId: spaceId.

"Step 2: Create a BankAccount model instance"
bankAccount1 := HsBankAccount id: '00001'.
bankAccount1 name: 'John Smith'; emailAddress: 'js@example.com'.

"Step 3: Register the model to the ModelSpace"
modelSpace putModel: bankAccount1.

"Retrieve the model by its ID"
modelSpace modelAt: '00001'. "-> returns bankAccount1"
```

### Explanation of the Code

1. **Creating a ModelSpace**:

   - The `spaceId:` method initializes a new `ModelSpace` with a unique identifier (`spaceId`).
   - This identifier ensures that the `ModelSpace` is distinct and can be referenced later.

2. **Creating a Model Instance**:

   - The `HsBankAccount` model is instantiated with a unique ID (`'00001'`).
   - Attributes such as `name` and `emailAddress` are set using accessor methods.

3. **Registering the Model**:
   - The `putModel:` method adds the model instance to the `ModelSpace`.
   - Once registered, the model can be retrieved using its ID with the `modelAt:` method.

### Important Notes

- **Model IDs**: Each model must have a unique ID within the `ModelSpace`. This ID is used to identify and retrieve the model.
- **Event-Driven Registration**: In a typical application, model registration is often performed through an event (e.g., `HsBankAccountCreated`). For simplicity, this example omits the event-based registration process.
- **Persistence**: The `ModelSpace` ensures that all registered models and their events are stored in a persistent repository, allowing for replay and recovery.

### Example Usage

Once the model is registered, you can perform operations such as depositing or withdrawing amounts, as shown in the next section. Here is an example of how to interact with the registered model:

```Smalltalk
"Deposit money into the account"
modelSpace deposit: 100 at: '00001'.

"Withdraw money from the account"
modelSpace withdraw: 30 at: '00001'.

"Check the balance"
modelSpace getBalanceAt: '00001'. "-> returns 70"
```

By registering models to a `ModelSpace`, you gain full control over their lifecycle and state, enabling powerful features such as event replay and auditing.

## Defining domain actions to ModelSpace

Next, add domain specific actions to HsBankAccountSpace.
It should support:

- Retrieving a balance of the specific account.
- Depositing an amount to the specific account.
- Withdrawing an amount from the specific account.

For Retrieving:

```
getBalanceAt: accountId
	| acc |
	acc := self modelAt: accountId.
	^ acc balance
```

For Depositing:

```
deposit: amount at: accountId
	| acc |
	acc := self modelAt: accountId.
	acc appendBalanceChange: amount.
	self save: acc
```

For withdrawing:

```
withdraw: amount at: accountId
	| acc |
	acc := self modelAt: accountId.
	acc appendBalanceChange: amount negated.
	self save: acc
```

Please note that `save:` is used after mutating an account. It stores event instances to the underlying repository for replay back.

Now you can:

```Smalltalk
modelSpace deposit: 100 at: '00001'.
modelSpace withdraw: 30 at: '00001'.
modelSpace getBalanceAt: '00001'. "-> returns 70"

```

## Replay back events and Snapshotting
