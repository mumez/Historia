# EventBridge を使用した他のモデルスペースとの連携

モデルスペースは、EventBridge を使用して相互に接続でき、それらの間の通信を容易にします。EventBridge は、スペース ID を使用して指定されたモデルスペースからイベント（または通知）を受信し、他のモデルスペースや外部サービスにメッセージを送信するための柔軟なイベントハンドラを実装します。

デフォルトでは、EventBridge は使いやすさのために単純なハンドラブロックの登録を使用します。ただし、Announcer フレームワーク上に構築されており、必要に応じてよりカスタマイズされたイベント処理動作が可能です。

この例では、`HtBankAccountMailBridge`というモックのブリッジを作成します。このブリッジは、銀行口座が他の口座から振り込みを受けたときに通知メールを送信するシミュレーションを行います。

## HtBankAccountMailBridge の定義

まず、`HtBankAccountMailBridge`クラスを定義します：

```Smalltalk
HsModelEventBridge << #HtBankAccountMailBridge
    slots: {};
    package: 'Historia-Examples-SimpleBank'
```

`HsModelEventBridge`は、`EventBridge`を作成するための抽象クラスです。

次に、通知イベントハンドラを登録する初期化メソッドを追加します：

```Smalltalk
(initialization)
initialize
    super initialize.
    self notificationAnnouncedDo: [ :announcement |
        announcement kind = #transferredTo ifTrue: [
            self handleTransferredToEvent: announcement event ] ]
```

`notificationAnnouncedDo:`を使用して通知イベントハンドラを登録します。この例では、`#transferredTo`タイプの通知を処理し、そのような通知を受信したときに`handleTransferredToEvent:`を呼び出します。

`handleTransferredToEvent:`では、別の ModelSpace と外部メールサービスを使用して、振り込み通知メールを送信するシミュレーションを行います：

```Smalltalk
(event handling)
handleTransferredToEvent: notificationEvent
    | accountId mailAddress |
    accountId := notificationEvent argsAt: 'to' ifAbsent: [ '' ].
    mailAddress := self mailAccountSpace getMailAddressAt: accountId.
    self externalMailService
        sendMailTo: mailAddress
        content: (self mailTemplateSpace
                 getContentAt: notificationEvent kind
                 values: notificationEvent arguments)
```

このメソッドは、振り込み通知イベントを処理し、受信者にメールを送信します：

1. まず、`argsAt:ifAbsent:`を使用してイベント引数から受信者の口座 ID を抽出します
2. 次に、モックの`mailAccountSpace`を使用して受信者のメールアドレスを検索します
3. 最後に、以下の手順でメールを送信します：
   - モックの`mailTemplateSpace`からメールテンプレートを取得します
   - テンプレートをイベント引数でフォーマットします
   - モックの`externalMailService`を使用してメールを送信します

簡単にするために、この例では実際のモデルスペースやサービスの代わりにモックを使用します：

```Smalltalk
(accessing)
mailAccountSpace
    ^ self
```

```Smalltalk
(accessing)
mailTemplateSpace
    ^ self
```

```Smalltalk
(accessing)
externalMailService
    ^ self
```

```Smalltalk
(mocking - template space)
getContentAt: templateKey values: templateValues
    ^ 'You just received {amount} from {from}' format: templateValues
```

```Smalltalk
(mocking - account space)
getMailAddressAt: accountId
    ^ { ('00001' -> 'john.smith@example.com') } asDictionary
          at: accountId
          ifAbsent: [ '' ]
```

```Smalltalk
(mocking - external mail service)
sendMailTo: mailAddress content: mailContent
    Transcript
        cr;
        show: ('## Send mail to: {1} content: {2}' format: {mailAddress. mailContent})
```

## HtBankAccountSpace への振り込みメソッドの追加

`HtBankAccountSpace`クラスに`transfer:from:to:`メソッドを追加して、口座間の振り込み機能を実装しましょう：

```Smalltalk
(actions)
transfer: amount from: fromAccountId to: toAccountId

    | fromAcc toAcc |
    fromAcc := self modelAt: fromAccountId.
    toAcc := self modelAt: toAccountId.
    fromAcc mutateBalanceChange: amount negated.
    toAcc mutateBalanceChange: amount.
    toAcc notify: #transferredTo withArguments: {
            (#to -> toAccountId).
            (#from -> fromAccountId).
            (#amount -> amount) }.
    self saveAll: {
            fromAcc.
            toAcc }
```

モデルに`#notify:withArguments:`メッセージを送信すると、通知イベントが作成されます。このイベントは、そのタイプを示すシンボル（「kind」と呼ばれる）によって特徴付けられ、さらにコンテキストや詳細を提供する追加の引数を含めることもできます。この通知は、作成時にすぐに送信されるわけではないことに注意することが重要です。代わりに、キューに入れられ、関連付けられたモデルが保存されたときにのみ送信されます。

### 説明：

1. **口座の取得**: メソッドは、送信者（`fromAcc`）と受信者（`toAcc`）の口座モデルを、それぞれの口座 ID を使用して取得します。
2. **残高の変更**: 送信者の口座に負の残高変更を適用し、受信者の口座に正の残高変更を適用します。
3. **振り込みの通知**: 受信者の口座に、関連する詳細（送信者、受信者、金額）を含む振り込みイベントの通知を行います。
4. **変更の保存**: 両方の口座モデルを保存して変更を永続化します。通知はこの時点で発行されます。

## 連携の実演

Playground で、`bankMailBridge`を設定して通知を処理します：

```Smalltalk
bankMailBridge := HtBankAccountMailBridge spaceId: spaceId.
bankMailBridge catchup.
```

また、口座`'00001'`に振り込むために別の銀行口座（`'00002'`）を作成する必要があります：

```Smalltalk
modelSpace putModelOf: HtBankAccount id: '00002' withArguments: {'name'->'Masashi Umezawa'}.
modelSpace deposit: 10000000 at: '00002'.
```

では、振り込みを実行しましょう：

```Smalltalk
modelSpace transfer: 2000 from: '00002' to: '00001'
```

Transcript に振り込みを示すメッセージが表示されます：

```
## Send mail to: john.smith@example.com content: You just received 2000 from 00002
```

## EventBridge での変更イベントの処理

前のセクションでは、EventBridge での通知イベントを使用した連携を実演しました。通知イベントは、アクションメソッド内で特定の状態変更を通知するのに役立ちます。

Historia はすべてのモデル変更にイベントを使用するため、EventBridge は任意の変更イベントを直接処理することもできます。この機能を実演するために、監査イベントブリッジを作成しましょう。簡単にするために、サブクラスを作成する代わりに、既存の`HsModelEventBridge`クラスを使用します。

```Smalltalk
auditorEventBridge := HsModelEventBridge spaceId: spaceId.
auditorEventBridge eventAnnouncedDo: [:ann | | event |
    event := ann event.
    Transcript cr; show: ('##{1} typeName:{2} arguments:{3}' format: { event targetId. event typeName. event arguments })
].
auditorEventBridge catchup.
```

`#catchup`を送信した後、ログがすでに Transcript に表示されていることに注意してください。これは、auditorEventBridge が最新の状態に追いつくためにイベントを再生したためです。

銀行口座でいくつかの変更を実行して、受信したイベントのログ記録が動作する様子を見てみましょう：

```Smalltalk
modelSpace deposit: 30 at: accId.
modelSpace withdraw: 40 at: accId.
modelSpace transfer: 5000 from: '00002' to: accId.
```

Transcript に変更ログが表示されます：

```Smalltalk
##00001 typeName:HtBankAccountBalanceChanged class arguments:a Dictionary('value'->30 )
##00001 typeName:HtBankAccountBalanceChanged class arguments:a Dictionary('value'->-40 )
##00002 typeName:HtBankAccountBalanceChanged class arguments:a Dictionary('value'->-5000 )
```
