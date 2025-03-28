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

## Implementing Mutations

Once the key classes are defined, the next step is to implement mutations. Mutations are the actions that modify the state of the model. These are performed by creating and applying events.

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

---

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

### Step 4: Using the Mutation in Practice

Now that the mutation is implemented, you can use it in your application. For example, to update the balance of a bank account:

```Smalltalk
| account |
account := HsBankAccount new.
account name: 'John Doe'; emailAddress: 'john.doe@example.com'; balance: 100.

"Mutate the balance"
account mutateBalanceChange: 50.

"Resulting balance"
account balance. "Should now be 150"
```

#### What Happens Internally:

1. The `mutateBalanceChange:` method creates a `HsBankAccountBalanceChanged` event.
2. The event is applied to the `HsBankAccount` model, updating the `balance` attribute.
3. The framework records the event, allowing it to be replayed or audited later.

---

### Final Notes

- **Event Sourcing Benefits**: By using events to track mutations, you gain the ability to audit changes, replay events to restore state, and debug issues by analyzing the event history.
- **Framework Integration**: The framework handles the creation, application, and storage of events, making it easy to implement complex business logic.

Now you are done implementing the `balance` mutation. You can proceed to explore how to manage snapshots and replay events in the `ModelSpace` to fully utilize the framework's capabilities!
