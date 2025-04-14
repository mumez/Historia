# モデルスペースへの BankAccount ドメインクラスの登録

## モデルスペースへのモデルの登録

モデルインスタンス（例：銀行口座）を ModelSpace に登録するには、以下の手順に従います：

1. **モデルスペースの作成**: `spaceId:`メソッドを使用して新しい ModelSpace インスタンスを作成します。
2. **モデルの登録**: `putModelOf:id:withArguments:`メソッドを使用して、モデルを ModelSpace に登録します。

以下は Playground での例です：

```Smalltalk
"ステップ1: モデルスペースの作成"
spaceId := 'bank-account-app-1'.
accId := '00001'.
modelSpace := HtBankAccountSpace spaceId: spaceId.

"ステップ2: モデルをモデルスペースに登録"
bankAccount1 := modelSpace putModelOf: HtBankAccount id: accId withArguments: {'name'->'John Smith'}.

"IDでモデルを取得"
modelSpace modelAt: accId. "-> bankAccount1を返す"
```

### 重要な注意点

- **モデル ID**: 各モデルは ModelSpace 内で一意の ID を持つ必要があります。この ID はモデルを識別して取得するために使用されます。
- **イベント駆動の登録**: `putModelOf:id:withArguments:`を使用することで、モデルの登録は内部イベント（例：`HsModelCreated`）を通じて実行されます。後で説明しますが、登録プロセスは再生可能です。
- **永続性**: ModelSpace は、登録されたすべてのモデルとそのイベントが永続的なリポジトリに保存されることを保証し、再生と回復を可能にします。

モデルを ModelSpace に登録することで、そのライフサイクルと状態を完全に制御でき、イベント再生や監査などの強力な機能を利用できるようになります。
