# 変更（ミューテーション）の実装

次のステップは変更（ミューテーション）の実装です。

変更は、モデルの状態を変更するアクションです。このフレームワークでは、すべての変更はイベントとして追跡され、すべての変更が記録され、後で再生や監査が可能になります。このセクションでは、変更を段階的に実装する方法を説明します。

## ステップ 1: モデルに変更メソッドを定義する

`HtBankAccount`モデルの`balance`属性を変更するために、`mutateBalanceChange:`という変更メソッドを定義します。このメソッドは、変更を記録するイベントを作成し、モデルに適用します。

```Smalltalk
(mutations)
mutateBalanceChange: newBalanceChange
    self mutate: HtBankAccountBalanceChanged using: [ :ev |
        ev value: newBalanceChange ]
```

### 重要なポイント：

1. **直接的な代入なし**: 通常のセッターメソッドとは異なり、このメソッドは`balance`属性に直接値を代入しません。
2. **イベントの作成**: `mutate:using:`メソッドを使用して、イベント（`HtBankAccountBalanceChanged`）を作成し、変更を記録します。
3. **イベントの設定**: ブロック`[ :ev | ev value: newBalanceChange ]`は、イベントの値を新しい残高変更に設定します。

これにより、変更がイベントとして記録され、変更を追跡して再生することが可能になります。

## ステップ 2: イベントクラスに適用メソッドを定義する

次のステップは、イベントをモデルにどのように適用するかを定義することです。これは、`HtBankAccountBalanceChanged`イベントクラスに`applyTo:`メソッドを実装することで行われます。

```Smalltalk
(applying)
applyTo: target
    target applyBalanceChange: self value
```

### 説明：

- `applyTo:`メソッドは、フレームワークによって呼び出され、イベントをターゲットモデル（この場合は`HtBankAccount`）に適用します。
- `self value`は、イベントに格納されている値（例：残高変更額）を取得します。
- その後、`applyBalanceChange:`メソッドがターゲットモデルで呼び出され、その状態が更新されます。

## ステップ 3: モデルに適用メソッドを定義する

最後に、`HtBankAccount`モデルに`applyBalanceChange:`メソッドを定義します。このメソッドは、イベントによって提供された値に基づいて`balance`属性を更新します。

```Smalltalk
(applying)
applyBalanceChange: newBalanceChange
    balance := balance + newBalanceChange
```

### 重要な注意点：

- **フレームワーク専用の使用**: `applyBalanceChange:`メソッドは、イベントを再生するときにフレームワークによってのみ呼び出されるべきです。アプリケーションコードで直接使用すべきではありません。なぜなら、イベント記録メカニズムがバイパスされてしまうためです。
- **履歴の追跡**: イベントを利用することで、フレームワークは`balance`属性へのすべての変更が追跡され、監査や再生が可能であることを保証します。

## 変更プロセスの概要

1. **変更メソッド**: モデルの`mutateBalanceChange:`メソッドがイベントを作成して適用します。
2. **イベントの適用**: イベントクラスの`applyTo:`メソッドが、イベントがモデルをどのように変更するかを定義します。
3. **状態の更新**: モデルの`applyBalanceChange:`メソッドが、イベントに基づいて状態を更新します。
