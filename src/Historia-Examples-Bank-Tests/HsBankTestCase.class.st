Class {
	#name : 'HsBankTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Examples-Bank-Tests',
	#package : 'Historia-Examples-Bank-Tests'
}

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
