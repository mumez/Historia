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
HsModel << #HtBankAccount
    slots: { #name . #balance };
    package: 'Historia-Examples-SimpleBank'
```

- `HsModel` is an abstract class provided by the framework for defining models.
- The `slots` define the attributes of the model. Here, we define `name` and `balance` as the attributes of the bank account.

Please add plain accessor(getter/setter) methods for `name`. For `balance`, we only need the getter, because we will add a mutation method for `balance` later.

Also add initializer:

```Smalltalk
initialize
   name := ''.
   balance := 0.
```

### Defining the Event Class

All changes to the model are performed through events. Each type of mutation requires a corresponding event class. For example, to handle changes to the bank account balance, we define an event class:

```Smalltalk
HsValueChanged << #HtBankAccountBalanceChanged
    slots: {};
    package: 'Historia-Examples-SimpleBank'
```

- `HsValueChanged` is a base class for events that represent changes to a model's value.
- The `slots` can be used to define additional data required for the event. In most cases, no additional data is needed, because superclass already defines slots for holding typical event values such as context, arguments, and user-id.

After defining the event class, you must explicitly register it to ensure the event serializer and deserializer function correctly. Without registration, the framework cannot process the event. You can register the event in the Playground as follows:

```Smalltalk
HtBankAccountBalanceChanged register
```

### Defining the ModelSpace (Aggregation)

The `ModelSpace` class is responsible for managing the lifecycle of models, including saving snapshots and replaying events. Here, we define a `HtBankAccountSpace` to manage `HtBankAccount` models.

```Smalltalk
HsModelSpace << #HtBankAccountSpace
    slots: {};
    package: 'Historia-Examples-SimpleBank'
```

- `HsModelSpace` is a base class for managing models.
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
(mutations)
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
(applying)
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
(applying)
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
2. **Register the Model**: Use the `putModelOf:id:withArguments:` method to register the model to the `ModelSpace`.

Here is an example for Playground:

```Smalltalk
"Step 1: Create a ModelSpace"
spaceId := 'bank-account-app-1'.
accId := '00001'.
modelSpace := HtBankAccountSpace spaceId: spaceId.

"Step 2: Register the model to the ModelSpace"
bankAccount1 := modelSpace putModelOf: HtBankAccount id: accId withArguments: {'name'->'John Smith'}.

"Retrieve the model by its ID"
modelSpace modelAt: accId. "-> returns bankAccount1"
```

### Important Notes

- **Model IDs**: Each model must have a unique ID within the `ModelSpace`. This ID is used to identify and retrieve the model.
- **Event-Driven Registration**: By using `putModelOf:id:withArguments:`, model registration is performed through an internal event (e.g., `HsModelCreated`). We will show you later, the registration process is replay-able.
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

---

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

---

### Important Notes

1. **Event Persistence**: The `save:` method ensures that pending events (in this case, HtBankAccountBalanceChanged instances) are stored in the underlying repository. This allows the framework to replay events and restore the state of the model at any point in time.
2. **Consistency**: By centralizing the logic for deposits and withdrawals in the `ModelSpace`, you ensure that all operations are consistent and follow the same rules.
3. **Error Handling**: In a real-world application, you should add error handling to check for conditions such as insufficient funds during withdrawals.

---

Here is an example of how these actions can be used together:

```Smalltalk
"Step 1: Deposit money into the account"
modelSpace deposit: 100 at: accId.

"Step 2: Withdraw money from the account"
modelSpace withdraw: 30 at: accId.

"Step 3: Retrieve the current balance"
modelSpace getBalanceAt: accId. "-> 70"
```

## Retrieving Saved Events

In this section, we explain how to retrieve events stored in the underlying repository and how to efficiently manage large numbers of events in real-world applications.

### Retrieving All Events

Each event is stored in the underlying Redis stream asynchronously when you save a model in a `ModelSpace`. You can retrieve all saved events using the `EventJournalStorage`:

```Smalltalk
modelSpace eventJournalStorage allEvents. "print it"
```

You can see tow events such as:

```
an OrderedCollection([#1744204795457-0: modelCreated targetIds:#('00001')]
[#1744204795460-0: HtBankAccountBalanceChanged class targetIds:#('00001')]
[#1744204797556-0: HtBankAccountBalanceChanged class targetIds:#('00001')])
```

Because you just sent `#deposit:at:` and `#withdraw:at:` to the bank account `ModelSpace`, two HtBankAccountBalanceChanged events are recorded.
You can also see modelCreated event at first. It was recorded when the bank account was registered by `putModelOf:id:withArguments:`.

Generally, the number of events can grow significantly over time.
So retrieving all events is not practical in real-world applications.
To retrieve the most recent event versions, send the `#eventVersionsReversedFromLast:` message. This method returns a limited number of event versions, starting with the newest and working backward.

```Smalltalk
modelSpace eventVersionsReversedFromLast: 5.
```

You can get:

```
an OrderedCollection('1744204797556-0' '1744204795460-0' '1744204795457-0')
```

---

## Snapshotting Model Space

Snapshots allow you to save the state of a `ModelSpace` at a specific point in time. By using snapshots, you can avoid replaying all past events, which improves performance when restoring the state of the `ModelSpace`.

### Saving a Snapshot

To save a snapshot of the current state of the `ModelSpace`, send the `#saveSnapshot` message:

```Smalltalk
modelSpace saveSnapshot.
```

Try taking another snapshot after sending `#deposit:at:`.

```Smalltalk
modelSpace deposit: 100 at: accId.
modelSpace saveSnapshot.
```

Now try getting all the snapshot versions using the following method:

```Smalltalk
modelSpace snapshotStorage listSnapshotVersions. "print it"
```

Of course, you can see two snapshot versions!

```Smalltalk
an OrderedCollection('1744205230917-0' '1744205252394-0')
```

You can also retrieve only the most recent ones sending `#snapshotVersionsReversedFromLast:`:

```Smalltalk
snapVersions := modelSpace snapshotVersionsReversedFromLast: 2.
```

```Smalltalk
an OrderedCollection('1744205252394-0' '1744205230917-0')
```

---

### Loading a Snapshot

To restore the state of the `ModelSpace` from a specific snapshot, send the `#loadSnapshot:` message:

```Smalltalk
modelSpace loadSnapshot: snapshotVersion.
```

Let's load the versions.

```Smalltalk
modelSpace loadSnapshot: snapVersions last.
modelSpace getBalanceAt: accId. "-> 70"

modelSpace loadSnapshot: snapVersions first.
modelSpace getBalanceAt: accId. "-> 170"
```

## Restoring ModelSpace by event replay

This time we will create another ModelSpace to demonstrate ModelSpace restoration via event replay.

```Smalltalk
modelSpace2 := HtBankAccountSpace spaceId: spaceId.
```

Of course modelSpace2 is just empty at this stage.

```Smalltalk
modelSpace2 models isEmpty. "-> true"
```

Let's try replaying events. We can send `#catchup`.

```Smalltalk
modelSpace2 catchup.
```

This method retrieves and replays events up to the latest version. If a snapshot is available, it uses the snapshot to restore the state and replays only the events that occurred after the snapshot. This ensures efficient restoration of the `ModelSpace` to the desired state.

Now you will get the result:

```Smalltalk
modelSpace2 getBalanceAt: accId. "-> 170"
```

## Automatic synchronization by catchup

Moreover, `modelSpace2` will automatically synchronize with the latest state as new incoming events are occurred in future.

For example, try sending additional `#deposit:at:` messages to the original `modelSpace`:

```Smalltalk
modelSpace deposit: 10 at: accId.
modelSpace deposit: 20 at: accId.
```

Now, send the `#getBalanceAt:` to `modelSpace2`. You will notice that it reflects the updated state of the model, including the latest deposits.

```Smalltalk
modelSpace2 getBalanceAt: accId. "-> 200"
```

This automatic synchronization ensures that all ModelSpace instances stay up-to-date with the incoming changes, making it useful for distributed systems where multiple components need to track the same state.

## Time Traveling: Exploring Past States

The framework allows you to easily "time travel" to view the state of your `ModelSpace` at any specific point in the past, identified by an event version (which acts like a timestamp). This is done using the `goTo:` method.

### How Time Traveling Works

1.  **Retrieve Event Versions**: First, you need the event version corresponding to the point in time you want to visit. You can get a list of recent event versions using `eventVersionsReversedFromLast:`.
2.  **Use `goTo:`**: Pass the desired event version to the `goTo:` method of your `ModelSpace` instance. The `ModelSpace` will then revert its state to exactly how it was _after_ that specific event occurred.

### Example: Traveling Through Account History

Let's retrieve the recent event versions for `modelSpace2`:

```Smalltalk
recentEventVersions := modelSpace2 eventVersionsReversedFromLast: 10. "print it"
```

This might give you a list like this (newest first):

```Smalltalk
an OrderedCollection('1744206010080-0' '1744206008674-0' '1744205251197-0'
'1744204797556-0' '1744204795460-0' '1744204795457-0')
```

Now, let's travel to different points in time:

**1. Go to the initial state (before any balance changes):**
The oldest event version is the last one in the list.

```Smalltalk
modelSpace2 goTo: recentEventVersions last. "Go to the initial version"
modelSpace2 getBalanceAt: accId. "-> 0"
```

**2. Go to the most recent state:**
The newest event version is the first one in the list.

```Smalltalk
modelSpace2 goTo: recentEventVersions first. "Go to the latest version"
modelSpace2 getBalanceAt: accId. "-> 200"
```

**3. Go to an intermediate state:**
Let's go to the state after the event `'1744205251197-0'` occurred (the third event version in our list).

```Smalltalk
modelSpace2 goTo: recentEventVersions third. "Go to the version '1744205251197-0'"
modelSpace2 getBalanceAt: accId. "-> 170"
```

This time-traveling capability is incredibly useful for debugging, auditing, or understanding how the model's state evolved over time.
Internally, the framework optimizes this time-traveling process for efficiency. When you use `goTo:`, it doesn't blindly replay every event from the very beginning. Instead, it first identifies and loads the most recent snapshot saved _before_ the target event version. Then, it only replays the events that occurred _between_ that snapshot and the target event version. This "differential replay" significantly speeds up the restoration process, especially when dealing with a large number of historical events, ensuring that `goTo:` remains efficient.

## Collaborating with Other ModelSpaces via EventBridge

`ModelSpaces` can be interconnected using an `EventBridge`, which facilitates communication between them. The `EventBridge` receives events (or notifications) from a specified `ModelSpace` using its space ID and implements flexible event handlers to send messages to other `ModelSpaces` or external services.

By default, the `EventBridge` uses simple handler block registration for ease of use. However, it is built on the Announcer framework, allowing for more customized event handling behaviors when needed.

In this example, we'll create a mock bridge called `HtBankAccountMailBridge`. This bridge simulates sending a notification email whenever a bank account receives a transfer from another account.

### Defining HtBankAccountMailBridge

First, define the `HtBankAccountMailBridge` class:

```Smalltalk
HsModelEventBridge << #HtBankAccountMailBridge
    slots: {};
    package: 'Historia-Examples-SimpleBank'
```

`HsModelEventBridge` is an abstract class for creating an `EventBridge`.

Next, add an initialization method to register a notification event handler:

```Smalltalk
(initialization)
initialize
    super initialize.
    self notificationAnnouncedDo: [ :announcement |
        announcement kind = #transferredTo ifTrue: [
            self handleTransferredToEvent: announcement event ] ]
```

Use `notificationAnnouncedDo:` to register a notification event handler. In this example, we handle notifications of type `#transferredTo` and call `handleTransferredToEvent:` when such a notification is received.

In `handleTransferredToEvent:`, we simulate sending a transfer notification email using another `ModelSpace` and an external mail service:

```Smalltalk
(event handling)
handleTransferredToEvent: notificationEvent
    | accountId mailAddress |
    accountId := notificationEvent argsAt: 'to' ifAbsent: [ '' ].
    mailAddress := self mailAccountSpace getMailAddressAt: accountId.
    self externalMailService
        sendMailTo: mailAddress
        content: (self mailTemplateSpace
                 getContentAt: notificationEvent kind
                 values: notificationEvent arguments)
```

This method processes a transfer notification event and sends an email to the recipient:

1. First, it extracts the recipient's account ID from the event arguments using `argsAt:ifAbsent:`
2. Then it looks up the recipient's email address using the mock `mailAccountSpace`
3. Finally, it sends an email by:
   - Getting an email template from the mock `mailTemplateSpace`
   - Formatting the template with the event arguments
   - Using the mock `externalMailService` to send the email

For simplicity, this example just uses mocks instead of actual ModelSpaces or services:

```Smalltalk
(accessing)
mailAccountSpace
    ^ self
```

```Smalltalk
(accessing)
mailTemplateSpace
    ^ self
```

```Smalltalk
(accessing)
externalMailService
    ^ self
```

```Smalltalk
(mocking - template space)
getContentAt: templateKey values: templateValues
    ^ 'You just received {amount} from {from}' format: templateValues
```

```Smalltalk
(mocking - account space)
getMailAddressAt: accountId
    ^ { ('00001' -> 'john.smith@example.com') } asDictionary
          at: accountId
          ifAbsent: [ '' ]
```

```Smalltalk
(mocking - external mail service)
sendMailTo: mailAddress content: mailContent
    Transcript
        cr;
        show: ('## Send mail to: {1} content: {2}' format: {mailAddress. mailContent})
```

### Adding a Transfer Method to HtBankAccountSpace

Let's add a `transfer:from:to:` method to the `HtBankAccountSpace` class to implement the transfer functionality between accounts:

```Smalltalk
(actions)
transfer: amount from: fromAccountId to: toAccountId

    | fromAcc toAcc |
    fromAcc := self modelAt: fromAccountId.
    toAcc := self modelAt: toAccountId.
    fromAcc mutateBalanceChange: amount negated.
    toAcc mutateBalanceChange: amount.
    toAcc notify: #transferredTo withArguments: {
            (#to -> toAccountId).
            (#from -> fromAccountId).
            (#amount -> amount) }.
    self saveAll: {
            fromAcc.
            toAcc }
```

#### Explanation:

1. **Retrieve Accounts**: The method retrieves the account models for both the sender (`fromAcc`) and the receiver (`toAcc`) using their account IDs.
2. **Mutate Balances**: It applies a negative balance change to the sender's account and a positive balance change to the receiver's account.
3. **Notify Transfer**: The receiver's account is notified of the transfer event with relevant details (sender, receiver, and amount).
4. **Save Changes**: Both account models are saved to persist the changes.

### Collaborating Together

In the Playground, set up the `bankMailBridge` to handle notifications:

```Smalltalk
bankMailBridge := HtBankAccountMailBridge spaceId: spaceId.
bankMailBridge catchup.
```

You'll also need to create another bank account (`'00002'`) to transfer money to account `'00001'`:

```Smalltalk
modelSpace putModelOf: HtBankAccount id: '00002' withArguments: {'name'->'Masashi Umezawa'}.
modelSpace deposit: 10000000 at: '00002'.
```

Now, perform a transfer:

```Smalltalk
modelSpace transfer: 2000 from: '00002' to: '00001'
```

You will see a message in the Transcript indicating the transfer:

```
## Send mail to: john.smith@example.com content: You just received 2000 from 00002
```

This example demonstrates how to implement and use a transfer method within the `HtBankAccountSpace`, enabling account-to-account transfers and notifications.
