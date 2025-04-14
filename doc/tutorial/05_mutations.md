# Implementing Mutations

The next step is to implement mutations.

Mutations are the actions that modify the state of the model. In this framework, all mutations are tracked as events, ensuring that every change is recorded and can be replayed or audited later. This section explains how to implement mutations step by step.

## Step 1: Define a Mutation Method in the Model

To modify the `balance` attribute of the `HtBankAccount` model, we define a mutation method called `mutateBalanceChange:`. This method creates an event to record the change and applies it to the model.

```Smalltalk
(mutations)
mutateBalanceChange: newBalanceChange
    self mutate: HtBankAccountBalanceChanged using: [ :ev |
        ev value: newBalanceChange ]
```

### Key Points:

1. **No Direct Assignment**: Unlike a typical setter method, this method does not directly assign a value to the `balance` attribute.
2. **Event Creation**: The `mutate:using:` method is used to create an event (`HtBankAccountBalanceChanged`) and record the change.
3. **Event Configuration**: The block `[ :ev | ev value: newBalanceChange ]` sets the value of the event to the new balance change.

This ensures that the mutation is recorded as an event, making it possible to track and replay changes.

## Step 2: Define an Apply Method in the Event Class

The next step is to define how the event should be applied to the model. This is done by implementing the `applyTo:` method in the `HtBankAccountBalanceChanged` event class.

```Smalltalk
(applying)
applyTo: target
    target applyBalanceChange: self value
```

### Explanation:

- The `applyTo:` method is called by the framework to apply the event to the target model (`HtBankAccount` in this case).
- The `self value` retrieves the value stored in the event (e.g., the balance change amount).
- The `applyBalanceChange:` method is then called on the target model to update its state.

## Step 3: Define the Apply Method in the Model

Finally, we define the `applyBalanceChange:` method in the `HtBankAccount` model. This method updates the `balance` attribute based on the value provided by the event.

```Smalltalk
(applying)
applyBalanceChange: newBalanceChange
    balance := balance + newBalanceChange
```

### Important Notes:

- **Framework-Only Usage**: The `applyBalanceChange:` method should only be called by the framework when replaying events. It should not be used directly in your application code, as this would bypass the event recording mechanism.
- **Historical Tracking**: By relying on events, the framework ensures that all changes to the `balance` attribute are tracked and can be audited or replayed.

## Summary of the Mutation Process

1. **Mutation Method**: The `mutateBalanceChange:` method in the model creates and applies an event.
2. **Event Application**: The `applyTo:` method in the event class defines how the event modifies the model.
3. **State Update**: The `applyBalanceChange:` method in the model updates the state based on the event.
