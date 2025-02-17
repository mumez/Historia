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
		       (HsBankAccountNotExist accountId: accountId) raise ].
	^ acc
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

{ #category : 'opening account' }
HsBankAccountSpace >> openAccount: modelId initializing: initializerBlock [
	| acc |
	acc := self putModelOf: HsBankAccountOpened id: modelId initializing: initializerBlock.
	self save: acc.
	^ acc id
]

{ #category : 'opening account' }
HsBankAccountSpace >> openAccount: modelId name: accountName emailAddress: emailAddress [
	^ self openAccount: modelId initializing: [ :acc |
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
HsBankAccountSpace >> withdraw: amount at: accountId [ 
	| acc |
	acc := self accountAt: accountId.
	acc appendBalanceChange: amount negated.
	self save: acc
]
