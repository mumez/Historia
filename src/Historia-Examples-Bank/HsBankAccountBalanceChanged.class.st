Class {
	#name : 'HsBankAccountBalanceChanged',
	#superclass : 'HsValueChanged',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'acccessing' }
HsBankAccountBalanceChanged class >> typeName [
	^ #ba:balanceChanged
]

{ #category : 'mutating' }
HsBankAccountBalanceChanged >> applyTo: target [
	target applyBalanceChange: self value
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
