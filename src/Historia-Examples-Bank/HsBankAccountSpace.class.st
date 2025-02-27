Class {
	#name : 'HsBankAccountSpace',
	#superclass : 'HsModelSpace',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'private' }
HsBankAccountSpace >> accountAt: accountId [
	| acc |
	acc := self
		       modelAt: accountId
		       ifAbsent: [
		       (HsBankAccountNotExist accountId: accountId) signal ].
	^ acc
]

{ #category : 'factory' }
HsBankAccountSpace >> bankAccountModelClass [
	^ HsBankAccount
]

{ #category : 'closing account' }
HsBankAccountSpace >> closeAccountAt: accountId [ 
	| acc |
	acc := self accountAt: accountId.
	acc close.
	self save: acc
]

{ #category : 'actions' }
HsBankAccountSpace >> deposit: amount at: accountId [ 
	| acc |
	acc := self accountAt: accountId.
	acc appendBalanceChange: amount.
	self save: acc
]

{ #category : 'actions' }
HsBankAccountSpace >> getBalanceAt: accountId [
	| acc |
	acc := self accountAt: accountId.
	^ acc balance
]

{ #category : 'actions' }
HsBankAccountSpace >> getOverdraftLimitAt: accountId [
	| acc |
	acc := self accountAt: accountId.
	^ acc overdraftLimit
]

{ #category : 'opening account' }
HsBankAccountSpace >> openAccount: accountId initializing: initializerBlock [
	| acc |
	acc := self putModelOf: self bankAccountModelClass id: accountId initializing: initializerBlock.
	self save: acc.
	^ acc id
]

{ #category : 'opening account' }
HsBankAccountSpace >> openAccount: accountId name: accountName emailAddress: emailAddress [
	^ self openAccount: accountId initializing: [ :acc |
		  acc
			  name: accountName;
			  emailAddress: emailAddress ]
]

{ #category : 'actions' }
HsBankAccountSpace >> overdraftLimit: overdraftLimit at: accountId [ 
	| acc |
	acc := self accountAt: accountId.
	acc overdraftLimit: overdraftLimit.
	self save: acc
]

{ #category : 'actions' }
HsBankAccountSpace >> transfer: amount from: fromAccountId to: toAccountId [
	| fromAcc toAcc |
	fromAcc := self accountAt: fromAccountId.
	toAcc := self accountAt: toAccountId.
	fromAcc appendBalanceChange: amount negated.
	toAcc appendBalanceChange: amount.
	self saveAll: {
			fromAcc.
			toAcc }
]

{ #category : 'actions' }
HsBankAccountSpace >> withdraw: amount at: accountId [ 
	| acc |
	acc := self accountAt: accountId.
	acc appendBalanceChange: amount negated.
	self save: acc
]
