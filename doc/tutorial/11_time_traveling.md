# Time Traveling: Exploring Past States

The framework allows you to easily "time travel" to view the state of your ModelSpace at any specific point in the past, identified by an event version (which acts like a timestamp). This is done using the `goTo:` method.

## How Time Traveling Works

1.  **Retrieve Event Versions**: First, you need the event version corresponding to the point in time you want to visit. You can get a list of recent event versions using `eventVersionsReversedFromLast:`.
2.  **Use `goTo:`**: Pass the desired event version to the `goTo:` method of your ModelSpace instance. The ModelSpace will then revert its state to exactly how it was _after_ that specific event occurred.

## Example: Traveling Through Account History

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
