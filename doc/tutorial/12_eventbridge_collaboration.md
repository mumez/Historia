# Collaborating with Other ModelSpaces via EventBridge

ModelSpaces can be interconnected using an EventBridge, which facilitates communication between them. The EventBridge receives events (or notifications) from a specified ModelSpace using its space ID and implements flexible event handlers to send messages to other ModelSpaces or external services.

By default, the EventBridge uses simple handler block registration for ease of use. However, it is built on the Announcer framework, allowing for more customized event handling behaviors when needed.

In this example, we'll create a mock bridge called `HtBankAccountMailBridge`. This bridge simulates sending a notification email whenever a bank account receives a transfer from another account.

## Defining HtBankAccountMailBridge

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

In `handleTransferredToEvent:`, we simulate sending a transfer notification email using another ModelSpace and an external mail service:

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
(mocking - account space)
getMailAddressAt: accountId
    ^ { ('00001' -> 'john.smith@example.com') } asDictionary
          at: accountId
          ifAbsent: [ '' ]
```

```Smalltalk
(mocking - template space)
getContentAt: templateKey values: templateValues
    ^ 'You just received {amount} from {from}' format: templateValues
```

```Smalltalk
(mocking - external mail service)
sendMailTo: mailAddress content: mailContent
    Transcript
        cr;
        show: ('## Send mail to: {1} content: {2}' format: {mailAddress. mailContent})
```

## Adding a Transfer Method to HtBankAccountSpace

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

When you send the message `#notify:withArguments:` to a model, it creates a notification event. This event is characterized by a symbol that indicates its type, known as the "kind," and it can also include additional arguments that provide further context or details. It is important to understand that this notification is not dispatched immediately upon creation. Instead, it is queued and will only be sent out when the model to which it is associated is saved.

### Explanation:

1. **Retrieve Accounts**: The method retrieves the account models for both the sender (`fromAcc`) and the receiver (`toAcc`) using their account IDs.
2. **Mutate Balances**: It applies a negative balance change to the sender's account and a positive balance change to the receiver's account.
3. **Notify Transfer**: The receiver's account is notified of the transfer event with relevant details (sender, receiver, and amount).
4. **Save Changes**: Both account models are saved to persist the changes. The notification is fired at this time.

## Collaborating Together

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

## Handling Mutation Events in EventBridge

In the previous section, we demonstrated collaboration using notification events in the EventBridge. Notification events are useful for signaling specific state changes within action methods.

Since Historia uses events for all model mutations, the EventBridge can also handle any mutation events directly. Let's create an auditor event bridge to demonstrate this capability. For simplicity, we'll just use the existing `HsModelEventBridge` class instead of creating a subclass.

```Smalltalk
auditorEventBridge := HsModelEventBridge spaceId: spaceId.
auditorEventBridge eventAnnouncedDo: [:ann | | event |
    event := ann event.
    Transcript cr; show: ('##{1} typeName:{2} arguments:{3}' format: { event targetId. event typeName. event arguments })
].
auditorEventBridge catchup.
```

Note that after sending `#catchup`, logs are already shown in Transcript. This is because auditorEventBridge replayed events to catchup to the latest state.

Let's perform some mutations on a bank account to see the incoming event logging in action:

```Smalltalk
modelSpace deposit: 30 at: accId.
modelSpace withdraw: 40 at: accId.
modelSpace transfer: 5000 from: '00002' to: accId.
```

You will see the mutation logs appear in Transcript:

```
##00001 typeName:HtBankAccountBalanceChanged class arguments:a Dictionary('value'->30 )
##00001 typeName:HtBankAccountBalanceChanged class arguments:a Dictionary('value'->-40 )
##00002 typeName:HtBankAccountBalanceChanged class arguments:a Dictionary('value'->-5000 )
```
