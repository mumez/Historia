# Tutorial

This tutorial explains how to use the framework by building a sample Bank Account application. The tutorial will guide you through defining the key classes and implementing the necessary components.

## Defining Key Classes

To develop an application using the framework, you need to define three main types of classes:

1. **Model**: Represents the core data structure of your application.
2. **Event**: Represents changes or mutations to the model.
3. **ModelSpace (Aggregation)**: Manages the lifecycle and state of models, including snapshots and event replay.

### Defining the Model Class

The `Model` class represents the main data structure of your application. In this example, we define a `HtBankAccount` model to represent a bank account.

```Smalltalk
HtModel << #HtBankAccount
    slots: { #name . #emailAddress . #balance };
    package: 'Historia-Examples-Bank'
```

- `HtModel` is an abstract class provided by the framework for defining models.
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
HtValueChanged << #HtBankAccountBalanceChanged
    slots: {};
    package: 'Historia-Examples-Bank'
```

- `HtValueChanged` is a base class for events that represent changes to a model's value.
- The `slots` can be used to define additional data required for the event. In most cases, no additional data is needed, because superclass already defines slots for holding typical event values such as context, arguments, and user-id.

### Defining the ModelSpace (Aggregation)

The `ModelSpace` class is responsible for managing the lifecycle of models, including saving snapshots and replaying events. Here, we define a `HtBankAccountSpace` to manage `HtBankAccount` models.

```Smalltalk
HtModelSpace << #HtBankAccountSpace
    slots: {};
    package: 'Historia-Examples-Bank'
```

- `HtModelSpace` is a base class for managing models.
- The `slots` can be used to define additional attributes or dependencies for the `ModelSpace`.

### Summary of Key Classes

- **Model**: Represents the structure of your data (e.g., `HtBankAccount`).
- **Event**: Represents changes to the model (e.g., `HtBankAccountBalanceChanged`).
- **ModelSpace**: Manages the state and lifecycle of models (e.g., `HtBankAccountSpace`).

Once the key classes are defined, the next step is to implement mutations. Mutations are the actions that modify the state of the model. These are performed by creating and applying events.

## Implementing Mutations

Mutations are the actions that modify the state of the model. In this framework, all mutations are tracked as events, ensuring that every change is recorded and can be replayed or audited later. This section explains how to implement mutations step by step.

### Step 1: Define a Mutation Method in the Model

To modify the `balance` attribute of the `HtBankAccount` model, we define a mutation method called `mutateBalanceChange:`. This method creates an event to record the change and applies it to the model.

```Smalltalk
mutateBalanceChange: newBalanceChange
    self mutate: HtBankAccountBalanceChanged using: [ :ev |
        ev value: newBalanceChange ]
```

#### Key Points:

1. **No Direct Assignment**: Unlike a typical setter method, this method does not directly assign a value to the `balance` attribute.
2. **Event Creation**: The `mutate:using:` method is used to create an event (`HtBankAccountBalanceChanged`) and record the change.
3. **Event Configuration**: The block `[ :ev | ev value: newBalanceChange ]` sets the value of the event to the new balance change.

This ensures that the mutation is recorded as an event, making it possible to track and replay changes.

---

### Step 2: Define an Apply Method in the Event Class

The next step is to define how the event should be applied to the model. This is done by implementing the `applyTo:` method in the `HtBankAccountBalanceChanged` event class.

```Smalltalk
applyTo: target
    target applyBalanceChange: self value
```

#### Explanation:

- The `applyTo:` method is called by the framework to apply the event to the target model (`HtBankAccount` in this case).
- The `self value` retrieves the value stored in the event (e.g., the balance change amount).
- The `applyBalanceChange:` method is then called on the target model to update its state.

---

### Step 3: Define the Apply Method in the Model

Finally, we define the `applyBalanceChange:` method in the `HtBankAccount` model. This method updates the `balance` attribute based on the value provided by the event.

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

In this section, we will register the `HtBankAccount` domain model to the `HtBankAccountSpace`. This step is essential because the `ModelSpace` is responsible for managing the lifecycle of models, including storing, retrieving, and replaying events.

### What is a ModelSpace?

A `ModelSpace` acts as a container for managing multiple model instances. It provides the following key functionalities:

- **Aggregation**: It aggregates model instances, allowing you to manage them collectively.
- **Lifecycle Management**: It handles the creation, updating, and deletion of models.
- **Event Replay**: It can replay events to restore the state of models to a specific point in time.

Each `ModelSpace` is identified by a unique `spaceId`, which allows you to create and manage multiple independent spaces.

### Registering a Model to a ModelSpace

To register a model instance (e.g., a bank account) to a `ModelSpace`, follow these steps:

1. **Create a ModelSpace**: Use the `spaceId:` method to create a new `ModelSpace` instance.
2. **Create a Model Instance**: Instantiate the `HtBankAccount` model and set its attributes.
3. **Register the Model**: Use the `putModel:` method to add the model to the `ModelSpace`.

Here is an example:

```Smalltalk
"Step 1: Create a ModelSpace"
spaceId := 'bank-account-app-1'.
modelSpace := HtBankAccountSpace spaceId: spaceId.

"Step 2: Create a BankAccount model instance"
bankAccount1 := HtBankAccount id: '00001'.
bankAccount1 name: 'John Smith'; emailAddress: 'js@example.com'.

"Step 3: Register the model to the ModelSpace"
modelSpace putModel: bankAccount1.

"Retrieve the model by its ID"
modelSpace modelAt: '00001'. "-> returns bankAccount1"
```

### Important Notes

- **Model IDs**: Each model must have a unique ID within the `ModelSpace`. This ID is used to identify and retrieve the model.
- **Event-Driven Registration**: In a typical application, model registration is often performed through an event (e.g., `HtBankAccountCreated`). For simplicity, this example omits the event-based registration process.
- **Persistence**: The `ModelSpace` ensures that all registered models and their events are stored in a persistent repository, allowing for replay and recovery.

By registering models to a `ModelSpace`, you gain full control over their lifecycle and state, enabling powerful features such as event replay and auditing.

## Defining Domain Actions to ModelSpace

In this section, we will define domain-specific actions for the `HtBankAccountSpace`. These actions allow you to interact with the `ModelSpace` to perform operations such as retrieving a balance, depositing money, and withdrawing money for specific accounts.

### Why Add Domain Actions?

The `ModelSpace` provides a generic mechanism for managing models, but domain-specific actions make it easier to encapsulate business logic and provide a clear API for interacting with the models. By defining these actions, you can:

- Simplify common operations (e.g., retrieving a balance).
- Ensure consistency by centralizing business logic.
- Improve code readability and maintainability.

### Actions to Implement

We will implement the following actions in the `HtBankAccountSpace`:

1. **Retrieving a Balance**: Get the current balance of a specific account.
2. **Depositing Money**: Add a specified amount to an account's balance.
3. **Withdrawing Money**: Subtract a specified amount from an account's balance.

---

### Retrieving a Balance

To retrieve the balance of a specific account, we define the `getBalanceAt:` method. This method takes an account ID as input, retrieves the corresponding model from the `ModelSpace`, and returns its balance.

```Smalltalk
getBalanceAt: accountId
    | acc |
    acc := self modelAt: accountId.
    ^ acc balance
```

#### Explanation:

1. **Retrieve the Model**: The `modelAt:` method fetches the model instance associated with the given `accountId`.
2. **Access the Balance**: The `balance` attribute of the model is returned.

**Example Usage**:

```Smalltalk
modelSpace getBalanceAt: '00001'. "-> returns the balance of account '00001'"
```

---

### Depositing Money

To deposit money into an account, we define the `deposit:at:` method. This method retrieves the account model, appends a balance change event, and saves the updated model.

```Smalltalk
deposit: amount at: accountId
    | acc |
    acc := self modelAt: accountId.
    acc appendBalanceChange: amount.
    self save: acc
```

#### Explanation:

1. **Retrieve the Model**: The `modelAt:` method fetches the account model.
2. **Append a Balance Change**: The `appendBalanceChange:` method records the deposit as an event.
3. **Save the Model**: The `save:` method persists the updated model and its events to the repository.

**Example Usage**:

```Smalltalk
modelSpace deposit: 100 at: '00001'. "Deposits 100 into account '00001'"
```

---

### Withdrawing Money

To withdraw money from an account, we define the `withdraw:at:` method. This method is similar to the deposit method but appends a negative balance change to represent the withdrawal.

```Smalltalk
withdraw: amount at: accountId
    | acc |
    acc := self modelAt: accountId.
    acc appendBalanceChange: amount negated.
    self save: acc
```

#### Explanation:

1. **Retrieve the Model**: The `modelAt:` method fetches the account model.
2. **Append a Negative Balance Change**: The `appendBalanceChange:` method records the withdrawal as an event by negating the amount.
3. **Save the Model**: The `save:` method persists the updated model and its events to the repository.

**Example Usage**:

```Smalltalk
modelSpace withdraw: 50 at: '00001'. "Withdraws 50 from account '00001'"
```

---

### Important Notes

1. **Event Persistence**: The `save:` method ensures that pending events (in this case, HtBankAccountBalanceChanged instances) are stored in the underlying repository. This allows the framework to replay events and restore the state of the model at any point in time.
2. **Consistency**: By centralizing the logic for deposits and withdrawals in the `ModelSpace`, you ensure that all operations are consistent and follow the same rules.
3. **Error Handling**: In a real-world application, you should add error handling to check for conditions such as insufficient funds during withdrawals.

---

### Example Workflow

Here is an example of how these actions can be used together:

```Smalltalk
"Step 1: Deposit money into the account"
modelSpace deposit: 100 at: '00001'.

"Step 2: Withdraw money from the account"
modelSpace withdraw: 30 at: '00001'.

"Step 3: Retrieve the current balance"
modelSpace getBalanceAt: '00001'. "-> returns 70"
```

## Retrieving Saved Events

In this section, we explain how to retrieve events stored in the underlying repository and how to efficiently manage large numbers of events in real-world applications.

### Retrieving All Events

Each event is stored in the underlying Redis stream asynchronously when you save a model in a `ModelSpace`. You can retrieve all saved events using the `EventJournalStorage`:

```Smalltalk
modelSpace eventJournalStorage allEvents. "print it"
```

You will see two events because you sent `#deposit:at:` and `#withdraw:at:` to the bank account `ModelSpace`.

#### Important Notes:

- **Performance Considerations**: Retrieving all events is not practical in real-world applications because the number of events can grow significantly over time.
- **Use Case**: This method is useful for debugging or analyzing the entire event history but should be avoided for routine operations.

---

### Retrieving Recent Events

To retrieve only the most recent events, you can use the `eventVersionsReversedFromLast:` method. This method fetches a specified number of events in reverse order, starting from the most recent event.

```Smalltalk
modelSpace eventVersionsReversedFromLast: 5.
```

#### Explanation:

- **Efficient Retrieval**: This method is more efficient than retrieving all events, especially when you only need the latest changes.
- **Use Case**: This is useful for scenarios like displaying recent activity or debugging the latest state changes.

---

## Snapshotting Model Space

Snapshots allow you to save the state of a `ModelSpace` at a specific point in time. By using snapshots, you can avoid replaying all past events, which improves performance when restoring the state of the `ModelSpace`.

### Saving a Snapshot

To save a snapshot of the current state of the `ModelSpace`, use the `saveSnapshot` method:

```Smalltalk
modelSpace saveSnapshot.
```

Try taking another snapshot after sending `#deposit:at:`.

```Smalltalk
modelSpace deposit: 100 at: '00001'.
modelSpace saveSnapshot.
```

Now try getting all the snapshot versions using the following method:

```Smalltalk
modelSpace snapshotStorage listSnapshotVersions. "inspect it"
```

Of course, you can see two snapshot versions!

Instead of listing all snapshots, it is better to retrieve only the most recent ones using `snapshotVersionsReversedFromLast:`:

```Smalltalk
modelSpace snapshotVersionsReversedFromLast: 5.
```

---

### Loading a Snapshot

To restore the state of the `ModelSpace` from a specific snapshot, use the `loadSnapshot:` method:

```Smalltalk
modelSpace loadSnapshot: snapshotVersion.
```

---

### Loading a Snapshot and Replaying Events

If you need to restore the state of the `ModelSpace` to a specific point in time after a snapshot, you can load the snapshot and replay only the events that occurred after the snapshot:

```Smalltalk
modelSpace loadSnapshot: snapshotVersion replayTo: toEventVersionId.
```

#### Explanation:

- **Optimized Replay**: By combining snapshots and event replay, you can efficiently restore the state without replaying all past events.
- **Use Case**: Useful for scenarios where you need to restore the state to a specific event version for auditing or debugging.

---
