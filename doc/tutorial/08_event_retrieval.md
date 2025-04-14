# Retrieving Saved Events

## Retrieving All Events

Each event is stored in the underlying Redis stream asynchronously when you save a model in a ModelSpace. You can retrieve all saved events using the `EventJournalStorage`:

```Smalltalk
modelSpace eventJournalStorage allEvents. "print it"
```

You can see tow events such as:

```
an OrderedCollection([#1744204795457-0: modelCreated targetIds:#('00001')]
[#1744204795460-0: HtBankAccountBalanceChanged class targetIds:#('00001')]
[#1744204797556-0: HtBankAccountBalanceChanged class targetIds:#('00001')])
```

Because you just sent `#deposit:at:` and `#withdraw:at:` to the bank account ModelSpace, two `HtBankAccountBalanceChanged` events are recorded.
Generally, the number of events can grow significantly over time.
So retrieving all events is not practical in real-world applications.
To retrieve the most recent event versions, send the `#eventVersionsReversedFromLast:` message. This method returns a limited number of event versions, starting with the newest and working backward.

```Smalltalk
modelSpace eventVersionsReversedFromLast: 5.
```

You can get:

```
an OrderedCollection('1744204797556-0' '1744204795460-0' '1744204795457-0')
```
