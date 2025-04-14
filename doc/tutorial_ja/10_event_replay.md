# イベント再生によるモデルスペースの復元

今回は、イベント再生によるモデルスペースの復元をデモするために、別のモデルスペースを作成します。

```Smalltalk
modelSpace2 := HtBankAccountSpace spaceId: spaceId.
```

もちろん、この段階では`modelSpace2`は空です。

```Smalltalk
modelSpace2 models isEmpty. "-> true"
```

イベントを再生してみましょう。`#catchup`を送信できます。

```Smalltalk
modelSpace2 catchup.
```

このメソッドは、最新バージョンまでのイベントを取得して再生します。スナップショットが利用可能な場合は、スナップショットを使用して状態を復元し、スナップショット以降に発生したイベントのみを再生します。これにより、ModelSpace を効率的に目的の状態に復元できます。

では結果を見てみましょう：

```Smalltalk
modelSpace2 getBalanceAt: accId. "-> 170"
```

## キャッチアップによる自動同期

さらに、`modelSpace2`は、将来新しいイベントが発生したときに、最新の状態と自動的に同期します。

例えば、元の`modelSpace`に追加の`#deposit:at:`メッセージを送信してみましょう：

```Smalltalk
modelSpace deposit: 10 at: accId.
modelSpace deposit: 20 at: accId.
```

次に、`modelSpace2`に`#getBalanceAt:`を送信します。最新の入金を含む更新されたモデルの状態が反映されていることがわかります。

```Smalltalk
modelSpace2 getBalanceAt: accId. "-> 200"
```

この自動同期により、すべてのモデルスペースインスタンスが受信した変更と最新の状態を維持し、同じ状態を追跡する必要がある複数のコンポーネントを持つ分散システムで役立ちます。
