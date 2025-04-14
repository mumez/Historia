# 保存されたイベントの取得

## すべてのイベントの取得

各イベントは、ModelSpace でモデルを保存するときに非同期で基盤となる Redis ストリームに保存されます。保存されたすべてのイベントは`EventJournalStorage`を使用して取得できます：

```Smalltalk
modelSpace eventJournalStorage allEvents. "print it"
```

以下のような 2 つのイベントが表示されます：

```
an OrderedCollection([#1744204795457-0: modelCreated targetIds:#('00001')]
[#1744204795460-0: HtBankAccountBalanceChanged class targetIds:#('00001')]
[#1744204797556-0: HtBankAccountBalanceChanged class targetIds:#('00001')])
```

これは、銀行口座の ModelSpace に`#deposit:at:`と`#withdraw:at:`を送信したため、2 つの`HtBankAccountBalanceChanged`イベントが記録されたためです。
一般的に、イベントの数は時間の経過とともに大幅に増加する可能性があります。
そのため、実際のアプリケーションではすべてのイベントを取得することは実用的ではありません。
最新のイベントバージョンを取得するには、`#eventVersionsReversedFromLast:`メッセージを送信します。このメソッドは、最新のものから始めて、指定された数のイベントバージョンを返します。

```Smalltalk
modelSpace eventVersionsReversedFromLast: 5.
```

以下のような結果が得られます：

```
an OrderedCollection('1744204797556-0' '1744204795460-0' '1744204795457-0')
```
