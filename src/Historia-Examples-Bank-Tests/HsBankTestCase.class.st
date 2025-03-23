Class {
	#name : 'HsBankTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Examples-Bank-Tests',
	#package : 'Historia-Examples-Bank-Tests'
}

{ #category : 'tests' }
HsBankTestCase >> testAccountDepositWithdraw [
	| spaceId bankApp accountId acc1 |
	spaceId := 'test-baDepositWithdraw'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	accountId := 'acc-1'.
	bankApp openAccount: accountId name: 'name-1' emailAddress: 'email-1'.
	acc1 := bankApp accountAt: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 0.
	bankApp deposit: 100 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 100.
	bankApp withdraw: 90 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 10.
	self
		should: [ bankApp withdraw: 20 at: accountId ]
		raise: HsBankAccountInsufficientFunds
		withExceptionDo: [ :ex | self assert: ex overdraftLimit equals: 0 ].
	self assert: (bankApp getBalanceAt: accountId) equals: 10.
]

{ #category : 'tests' }
HsBankTestCase >> testAccountInactive [
	| spaceId bankApp accountId acc1 closedTimestamp |
	spaceId := 'test-baAccountInactive'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	accountId := 'acc-1'.
	bankApp openAccount: accountId name: 'name-1' emailAddress: 'email-1'.
	acc1 := bankApp accountAt: accountId.
	self assert: acc1 name equals: 'name-1'.
	self assert: acc1 emailAddress equals: 'email-1'.
	self assert: (bankApp getBalanceAt: accountId) equals: 0.
	bankApp deposit: 100 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 100.
	bankApp withdraw: 10 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 90.
	bankApp closeAccountAt: accountId.
	self assert: (bankApp accountAt: accountId) isClosed.
	closedTimestamp := (bankApp accountAt: accountId) closedTimestamp.
	self
		should: [ bankApp withdraw: 50 at: accountId ]
		raise: HsBankAccountInactive
		withExceptionDo: [ :ex | self assert: closedTimestamp equals: ex closedTimestamp ].
	self assert: (bankApp getBalanceAt: accountId) equals: 90.
]

{ #category : 'tests' }
HsBankTestCase >> testAccountNotExist [
	| spaceId bankApp accountId acc1 noSuchAccountId |
	spaceId := 'test-baAccountNotExist'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	accountId := 'acc-1'.
	bankApp openAccount: accountId name: 'name-1' emailAddress: 'email-1'.
	acc1 := bankApp accountAt: accountId.
	self assert: acc1 name equals: 'name-1'.
	self assert: acc1 emailAddress equals: 'email-1'.
	self assert: (bankApp getBalanceAt: accountId) equals: 0.
	noSuchAccountId := 'no-such-acc-1'.
	self
		should: [ bankApp accountAt: 'no-such-acc-1' ]
		raise: HsBankAccountNotExist
		withExceptionDo: [ :ex | self assert: noSuchAccountId equals: ex accountId ].

]

{ #category : 'tests' }
HsBankTestCase >> testAccountOpen [
	| spaceId bankApp accountId acc1 |
	spaceId := 'test-baAccountOpen'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	accountId := 'acc-1'.
	bankApp openAccount: accountId name: 'name-1' emailAddress: 'email-1'.
	acc1 := bankApp accountAt: accountId.
	self assert: acc1 name equals: 'name-1'.
	self assert: acc1 emailAddress equals: 'email-1'.
	self assert: (bankApp getBalanceAt: accountId) equals: 0.
	
	
	
	
	
]

{ #category : 'tests' }
HsBankTestCase >> testAccountTransfer [
	| spaceId bankApp accountId1 acc1 accountId2 acc2 |
	spaceId := 'test-baAccountTransfer'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	accountId1 := 'acc-1'.
	bankApp openAccount: accountId1 name: 'name-1' emailAddress: 'email-1'.
	accountId2 := 'acc-2'.
	bankApp openAccount: accountId2 name: 'name-2' emailAddress: 'email-2'.
	acc1 := bankApp accountAt: accountId1.
	self assert: acc1 name equals: 'name-1'.
	self assert: acc1 emailAddress equals: 'email-1'.
	self assert: (bankApp getBalanceAt: accountId1) equals: 0.
	acc2 := bankApp accountAt: accountId2.
	self assert: acc2 name equals: 'name-2'.
	self assert: acc2 emailAddress equals: 'email-2'.
	self assert: (bankApp getBalanceAt: accountId2) equals: 0.
	bankApp deposit: 100 at: accountId1.
	bankApp deposit: 10 at: accountId2. 
	self assert: (bankApp getBalanceAt: accountId1) equals: 100.
	self assert: (bankApp getBalanceAt: accountId2) equals: 10.
	bankApp transfer: 50 from: accountId1 to: accountId2.
	self assert: (bankApp getBalanceAt: accountId1) equals: 50.
	self assert: (bankApp getBalanceAt: accountId2) equals: 60.
	bankApp transfer: 60 from: accountId2 to: accountId1.
	self assert: (bankApp getBalanceAt: accountId1) equals: 110.
	self assert: (bankApp getBalanceAt: accountId2) equals: 0.
	self
		should: [ bankApp transfer: 10 from: accountId2 to: accountId1. ]
		raise: HsBankAccountInsufficientFunds
		withExceptionDo: [ :ex | self assert: ex overdraftLimit equals: 0 ].
	
	
	
	
]

{ #category : 'tests' }
HsBankTestCase >> testAccountWithdrawOverdraftLimitSet [
	| spaceId bankApp accountId acc1 |
	spaceId := 'test-baWithdrawOverdraftLimitSet'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	accountId := 'acc-1'.
	bankApp openAccount: accountId name: 'name-1' emailAddress: 'email-1'.
	acc1 := bankApp accountAt: accountId.
	bankApp deposit: 100 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 100.
	bankApp overdraftLimit: 50 at: accountId.
	self assert: (bankApp getOverdraftLimitAt: accountId) equals: 50.
	bankApp withdraw: 90 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 10.
	bankApp withdraw: 30 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: -20.
	bankApp withdraw: 30 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: -50.
	self
		should: [ bankApp withdraw: 1 at: accountId ]
		raise: HsBankAccountInsufficientFunds
		withExceptionDo: [ :ex | self assert: ex overdraftLimit equals: 50 ].
	self assert: (bankApp getBalanceAt: accountId) equals: -50.
]

{ #category : 'tests' }
HsBankTestCase >> testAccountsPropagated [
	| spaceId bankApp accountId acc1 readBankApp readAcc1 |
	spaceId := 'test-baAccountsPropagated'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	readBankApp := HsBankAccountSpace spaceId: spaceId.
	self spaces: { bankApp. readBankApp } do: [
	bankApp startPushingEvents.
	accountId := 'acc-1'.
	bankApp openAccount: accountId name: 'name-1' emailAddress: 'email-1'.
	acc1 := bankApp accountAt: accountId.
	bankApp deposit: 100 at: accountId.
	bankApp withdraw: 90 at: accountId.
	self assert: (bankApp getBalanceAt: accountId) equals: 10.
	bankApp eventPusher waitEmptyFor: 100.
	readBankApp catchup.
	readAcc1 := readBankApp accountAt: accountId.
	self assert: (readBankApp getBalanceAt: accountId) equals: 10.
	bankApp deposit: 100 at: accountId.
	bankApp eventPusher waitEmptyFor: 100.
	self assert: (readBankApp getBalanceAt: accountId) equals: 110.
	].
]

{ #category : 'tests' }
HsBankTestCase >> testAccountsTransferNotified [
	| spaceId bankApp accountId1 acc1 accountId2 acc2 notifiedApp events transferedNotices transferedNotice |
	spaceId := 'test-baTransferNotified'.
	bankApp := HsBankAccountSpace spaceId: spaceId.
	notifiedApp := HsAnnouncingModelEventSink spaceId: spaceId.
	events := OrderedCollection new.
	transferedNotices := OrderedCollection new.
	notifiedApp 
		eventAnnouncedDo: [:ann | events add: ann event];
		notificationAnnouncedDo: [:ann | ann event kind = #tranferedTo ifTrue: [transferedNotices add: ann event arguments]].
	self spaces: { bankApp. notifiedApp } do: [
	bankApp startPushingEvents.
	accountId1 := 'acc-1'.
	bankApp openAccount: accountId1 name: 'name-1' emailAddress: 'email-1'.
	accountId2 := 'acc-2'.
	bankApp openAccount: accountId2 name: 'name-2' emailAddress: 'email-2'.
	acc1 := bankApp accountAt: accountId1.
	acc2 := bankApp accountAt: accountId2.
	bankApp deposit: 100 at: accountId1.
	bankApp deposit: 10 at: accountId2.
	bankApp eventPusher waitEmptyFor: 100.
	notifiedApp catchup.
	self assert: (notifiedApp modelAt: accountId1) balance equals: 100.
	bankApp transfer: 50 from: accountId1 to: accountId2.
	bankApp eventPusher waitEmptyFor: 100.
	self assert: (notifiedApp modelAt: accountId2) balance equals: 60.
	self assert: events size equals: 6.
	self assert: events last targetId equals: 'acc-2'.
	self assert: (events last  argsAt: 'value') equals: 50.	
	self assert: transferedNotices size equals: 1.
	transferedNotice := transferedNotices first.
	self assert: (transferedNotice at: 'from') equals: 'acc-1'.
	self assert: (transferedNotice at: 'amount') equals: 50.
	].
]
