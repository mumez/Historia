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
