# Event Implementation

## Defining the Event Class

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
