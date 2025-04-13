# Model Implementation

## Defining the Model Class

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
