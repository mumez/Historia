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
