# ModelSpace Implementation

## Defining the ModelSpace (Aggregation)

The ModelSpace class is responsible for managing the lifecycle of models, including saving snapshots and replaying events. Here, we define a `HtBankAccountSpace` to manage `HtBankAccount` models.

```Smalltalk
HsModelSpace << #HtBankAccountSpace
    slots: {};
    package: 'Historia-Examples-SimpleBank'
```

- `HsModelSpace` is a base class for managing models.
- The `slots` can be used to define additional attributes or dependencies for the `ModelSpace`.

### What is a ModelSpace?

A `ModelSpace` acts as a container for managing multiple model instances. It provides the following key functionalities:

- **Aggregation**: It aggregates model instances, allowing you to manage them collectively.
- **Lifecycle Management**: It handles the creation, updating, and deletion of models.
- **Event Replay**: It can replay events to restore the state of models to a specific point in time.

Each `ModelSpace` is identified by a unique `spaceId`, which allows you to create and manage multiple independent spaces.
