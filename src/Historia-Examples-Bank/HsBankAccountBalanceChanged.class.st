Class {
	#name : 'HsBankAccountBalanceChanged',
	#superclass : 'HsValueChanged',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'mutating' }
HsBankAccountBalanceChanged >> applyTo: target [
	target applyBalance: self value
]

{ #category : 'actions' }
HsBankAccountBalanceChanged >> setTransactionId [
	self transactionId: UUID new asString36
]

{ #category : 'accessing' }
HsBankAccountBalanceChanged >> transactionId [

	^ self contextAt: 'transactionId'
]

{ #category : 'accessing' }
HsBankAccountBalanceChanged >> transactionId: newValue [

	self contextAt: 'transactionId' put: newValue
]
