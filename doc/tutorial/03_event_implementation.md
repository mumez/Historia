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

The event class also requires a unique type name. It is used by the framework for event dispatching.

Let's define #typeName class method to `HtBankAccountBalanceChanged`.

```Smalltalk
(class side) (accessing)
typeName
	^ self name
```

In this example, the class name is used as the type name. However, in real-world applications, it is recommended to use a shorter name, as this name is serialized into the event stream every time an event is sent.

After defining the event class, you must explicitly register it to ensure the event serializer and deserializer function correctly. Without registration, the framework cannot process the event. You can register the event in the Playground as follows:

```Smalltalk
HtBankAccountBalanceChanged register
```

For better maintainability, it is a good practice to define a class initialization method that automatically registers the event class when the source code is loaded:

```Smalltalk
(class side) (class initialization)
initialize
	self register
```
