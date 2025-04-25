# イベントの実装

## イベントクラスの定義

モデルへのすべての変更はイベントを通じて実行されます。各タイプの変更には対応するイベントクラスが必要です。例えば、銀行口座の残高変更を処理するために、以下のようなイベントクラスを定義します：

```Smalltalk
HsValueChanged << #HtBankAccountBalanceChanged
    slots: {};
    package: 'Historia-Examples-SimpleBank'
```

- `HsValueChanged`は、モデルの値の変更を表現するイベントの基底クラスです。
- `slots`は、イベントに必要な追加データを定義するために使用できます。ほとんどの場合、追加データは必要ありません。なぜなら、スーパークラスが既にコンテキスト、引数、ユーザー ID などの一般的なイベント値を保持するためのスロットを定義しているためです。

イベントクラスには一意のタイプ名が必要です。このタイプ名は、フレームワークがイベントをディスパッチする際に使用されます。

`HtBankAccountBalanceChanged` に対して `#typeName` クラスメソッドを定義してみましょう。

```Smalltalk
(class side) (accessing)
typeName
	^ self name
```

この例では、クラス名がタイプ名として使用されています。ただし、実際のアプリケーションでは、より短い名前を使用することを推奨します。タイプ名はイベントストリームに送信されるたびにシリアライズされるものだからです。

イベントクラスを定義した後、イベントのシリアライザとデシリアライザが正しく機能するように、明示的に登録する必要があります。登録がない場合、フレームワークはイベントを処理できません。以下のようにしてイベントを Playground で登録できます：

```Smalltalk
HtBankAccountBalanceChanged register
```

保守性を向上させるため、クラス初期化メソッドを定義しておくと良いでしょう。これによりソースがロードされたときに自動的にイベントクラスが登録されます：

```Smalltalk
(class side) (class initialization)
initialize
	self register
```
