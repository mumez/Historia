# モデルスペースのスナップショット

スナップショットを使用すると、特定の時点での ModelSpace の状態を保存できます。スナップショットを使用することで、過去のすべてのイベントを再生する必要がなくなり、ModelSpace の状態を復元する際のパフォーマンスが向上します。

## スナップショットの保存

ModelSpace の現在の状態のスナップショットを保存するには、`#saveSnapshot`メッセージを送信します：

```Smalltalk
modelSpace saveSnapshot.
```

`#deposit:at:`を送信した後に、もう一度スナップショットを取得してみましょう。

```Smalltalk
modelSpace deposit: 100 at: accId.
modelSpace saveSnapshot.
```

次に、以下のメソッドを使用してすべてのスナップショットバージョンを取得してみましょう：

```Smalltalk
modelSpace snapshotStorage listSnapshotVersions. "print it"
```

もちろん、2 つのスナップショットバージョンが表示されます！

```Smalltalk
an OrderedCollection('1744205230917-0' '1744205252394-0')
```

最新のスナップショットのみを取得するには、`#snapshotVersionsReversedFromLast:`を送信します：

```Smalltalk
snapVersions := modelSpace snapshotVersionsReversedFromLast: 2.
```

```Smalltalk
an OrderedCollection('1744205252394-0' '1744205230917-0')
```

## スナップショットの読み込み

特定のスナップショットから ModelSpace の状態を復元するには、`#loadSnapshot:`メッセージを送信します：

```Smalltalk
modelSpace loadSnapshot: snapshotVersion.
```

バージョンを読み込んでみましょう。

```Smalltalk
modelSpace loadSnapshot: snapVersions last.
modelSpace getBalanceAt: accId. "-> 70"

modelSpace loadSnapshot: snapVersions first.
modelSpace getBalanceAt: accId. "-> 170"
```
