# Historia

[Event sourcing](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing) implementation in Pharo Smalltalk.

## Features

- Model objects' mutations are recorded as events with timestamps.
- ModelSpace (Aggregation) can manage model objects with specific names.
- ModelSpace can save the states of managed objects as snapshots.
- ModelSpace can load object states from snapshots or replay events to return to any timestamp.
- ModelSpaces can be notified of mutations or notifications from other ModelSpaces.
- Snapshots and events are stored in reliable persistent storage (currently Redis is used).
- A Bank Account example is included to demonstrate how to use the framework.
- Extensible:
  - Customizable Event/Snapshot codecs (STON and Fuel are used by default)
  - Customizable Model and ModelSpace behaviors (for example, you can add audit logs for all mutations)

## Installation

```smalltalk
Metacello new
  baseline: 'Historia';
  repository: 'github://mumez/Historia/src';
  load.
```

## Quick example

```Smalltalk
spaceId := 'sample-space'.

"Step 1: Create a ModelSpace for managing models"
modelSpace := HsModelSpace spaceId: spaceId.

"Step 2: Register a Model (In a real application, you would register a domain-specific model. Here, we use a generic HsOrderedCollectionModel for demonstration purposes)"
modelSpace putModelOf: HsOrderedCollectionModel id: 'numbers'.
vmodel := modelSpace modelAt: 'numbers'.

"Step 3: Perform operations on the model (e.g., adding numbers to a collection)"
1 to: 5 do: [ :idx | vmodel add: idx ].

"Step 4: Save the model state (All mutations are recorded as events and saved to the event stream)"
vmodel save.

"Step 5: Create another ModelSpace for replaying events"
modelSpace2 := HsModelSpace spaceId: spaceId.

"Step 6: Catch up to the current state by replaying mutation events"
modelSpace2 catchup.

"Step 7: Print the model state (You may need to wait briefly for the events to propagate)"
(modelSpace2 modelAt: 'numbers') values. "-> an OrderedCollection(1 2 3 4 5)"
```

## How to use the framework

Please see the

- [Tutorial](./doc/tutorial)
- [チュートリアル(日本語)](./doc/tutorial_ja)
