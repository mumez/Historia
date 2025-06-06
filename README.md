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

In Playground:

```smalltalk
Metacello new
  baseline: 'Historia';
  repository: 'github://mumez/Historia:main/src';
  load.
```

If Redis is not running, you will also need to:

```
docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest
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

## FAQ

### Q: How to change Redis connection address / port?

A: Send `#targetUrl:` to `RsStreamSettings` default instance:

```Smalltalk
RsStreamSettings default targetUrl: 'sync://localhost:6379'
```

### Q: How do I use other event codecs?

A: Set the event codec by sending `#eventCodec:` to the modelSpace's settings:

```Smalltalk
modelSpace settings eventCodec: #json.
```

The JSON codec is useful if you want to receive Historia events from other systems via the Redis event stream.

If you need a more compact event format, you can use the MessagePack codec:

```Smalltalk
modelSpace settings eventCodec: #mp.
```

Note: The MessagePack codec is provided as an optional package. To use it, you must explicitly load it:

```Smalltalk
Metacello new
  baseline: 'Historia';
  repository: 'github://mumez/Historia:main/src';
  load: #('default' 'MessagePackCodec-Tests').
```
