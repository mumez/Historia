# Registering BankAccount Domain Class to ModelSpace

## Registering a Model to a ModelSpace

To register a model instance (e.g., a bank account) to a ModelSpace, follow these steps:

1. **Create a ModelSpace**: Use the `spaceId:` method to create a new ModelSpace instance.
2. **Register the Model**: Use the `putModelOf:id:withArguments:` method to register the model to the ModelSpace.

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

- **Model IDs**: Each model must have a unique ID within the ModelSpace. This ID is used to identify and retrieve the model.
- **Event-Driven Registration**: By using `putModelOf:id:withArguments:`, model registration is performed through an internal event (e.g., `HsModelCreated`). We will show you later, the registration process is replay-able.
- **Persistence**: The ModelSpace ensures that all registered models and their events are stored in a persistent repository, allowing for replay and recovery.

By registering models to a ModelSpace, you gain full control over their lifecycle and state, enabling powerful features such as event replay and auditing.
