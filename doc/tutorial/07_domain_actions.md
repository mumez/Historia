# Defining Domain Actions to ModelSpace

## Why Add Domain Actions?

The `ModelSpace` provides a generic mechanism for managing models, but domain-specific actions make it easier to encapsulate business logic and provide a clear API for interacting with the models. By defining these actions, you can:

- Simplify common operations (e.g., retrieving a balance).
- Ensure consistency by centralizing business logic.
- Improve code readability and maintainability.

## Actions to Implement

We will implement the following actions in the `HtBankAccountSpace`:

1. **Retrieving a Balance**: Get the current balance of a specific account.
2. **Depositing Money**: Add a specified amount to an account's balance.
3. **Withdrawing Money**: Subtract a specified amount from an account's balance.

### Retrieving a Balance

To retrieve the balance of a specific account, we define the `getBalanceAt:` method. This method takes an account ID as input, retrieves the corresponding model from the `ModelSpace`, and returns its balance.

```Smalltalk
(actions)
getBalanceAt: accountId
    | acc |
    acc := self modelAt: accountId.
    ^ acc balance
```

#### Explanation:

1. **Retrieve the Model**: The `modelAt:` method fetches the model instance associated with the given `accountId`.
2. **Access the Balance**: The `balance` attribute of the model is returned.

### Depositing Money

To deposit money into an account, we define the `deposit:at:` method. This method retrieves the account model, appends a balance change event, and saves the updated model.

```Smalltalk
(actions)
deposit: amount at: accountId
    | acc |
    acc := self modelAt: accountId.
    acc mutateBalanceChange: amount.
    self save: acc
```

#### Explanation:

1. **Retrieve the Model**: The `modelAt:` method fetches the account model.
2. **Mutate with a Balance Change**: The `mutateBalanceChange:` method records the deposit as an event.
3. **Save the Model**: The `save:` method persists the updated model and its events to the repository.

### Withdrawing Money

To withdraw money from an account, we define the `withdraw:at:` method. This method is similar to the deposit method but appends a negative balance change to represent the withdrawal.

```Smalltalk
(actions)
withdraw: amount at: accountId
    | acc |
    acc := self modelAt: accountId.
    acc mutateBalanceChange: amount negated.
    self save: acc
```

#### Explanation:

1. **Retrieve the Model**: The `modelAt:` method fetches the account model.
2. **Mutate with a Negative Balance Change**: The `mutateBalanceChange:` method records the withdrawal as an event by negating the amount.
3. **Save the Model**: The `save:` method persists the updated model and its events to the repository.

### Important Notes

1. **Event Persistence**: The `save:` method ensures that pending events (in this case, HtBankAccountBalanceChanged instances) are stored in the underlying repository. This allows the framework to replay events and restore the state of the model at any point in time.
2. **Consistency**: By centralizing the logic for deposits and withdrawals in the `ModelSpace`, you ensure that all operations are consistent and follow the same rules.
3. **Error Handling**: In a real-world application, you should add error handling to check for conditions such as insufficient funds during withdrawals.

Here is an example of how these actions can be used together:

```Smalltalk
"Step 1: Deposit money into the account"
modelSpace deposit: 100 at: accId.

"Step 2: Withdraw money from the account"
modelSpace withdraw: 30 at: accId.

"Step 3: Retrieve the current balance"
modelSpace getBalanceAt: accId. "-> 70"
```
