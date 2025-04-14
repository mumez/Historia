# モデルの実装

## モデルクラスの定義

モデルクラスは、アプリケーションの主要なデータ構造を表現します。この例では、銀行口座を表現するために`HtBankAccount`モデルを定義します。

```Smalltalk
HsModel << #HtBankAccount
    slots: { #name . #balance };
    package: 'Historia-Examples-SimpleBank'
```

- `HsModel`は、モデルを定義するためにフレームワークが提供する抽象クラスです。
- `slots`はモデルの属性を定義します。ここでは、銀行口座の属性として`name`と`balance`を定義しています。

`name`に対しては通常のアクセサ（getter/setter）メソッドを追加してください。`balance`については、後で変更メソッドを追加するため、getter のみ必要です。

また、初期化メソッドも追加します：

```Smalltalk
initialize
   name := ''.
   balance := 0.
```
