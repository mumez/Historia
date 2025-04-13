# Snapshotting Model Space

Snapshots allow you to save the state of a `ModelSpace` at a specific point in time. By using snapshots, you can avoid replaying all past events, which improves performance when restoring the state of the `ModelSpace`.

## Saving a Snapshot

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

## Loading a Snapshot

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
