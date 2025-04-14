# Restoring ModelSpace by Event Replay

This time we will create another ModelSpace to demonstrate ModelSpace restoration via event replay.

```Smalltalk
modelSpace2 := HtBankAccountSpace spaceId: spaceId.
```

Of course `modelSpace2` is just empty at this stage.

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

## Automatic Synchronization by Catchup

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
