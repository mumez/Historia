Class {
	#name : 'HsBankAccount',
	#superclass : 'HsModel',
	#instVars : [
		'name',
		'emailAddress',
		'balance',
		'overdraftLimit',
		'closedTimestamp'
	],
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'mutating' }
HsBankAccount >> appendBalanceChange: newChange [
	self assertNotClosed.
	self assertWithinOverdraftLimit: newChange.
	self mutate: HsBankAccountBalanceChanged using: [ :ev |
		ev
			setTransactionId;
			value: newChange ]
]

{ #category : 'applying' }
HsBankAccount >> applyBalanceChange: newBalanceChange [
	self isClosed ifTrue: [ self error: 'Closed' ].
]

{ #category : 'applying' }
HsBankAccount >> applyClosedTimestamp: aClosedTimestamp [
	closedTimestamp := aClosedTimestamp 
]

{ #category : 'applying' }
HsBankAccount >> applyInitialize: aName emailAddress: anEmailAddress [
	name := aName.
	emailAddress := anEmailAddress 
]

{ #category : 'applying' }
HsBankAccount >> applyOverdraftLimit: newLimit [
	overdraftLimit := newLimit 
]

{ #category : 'asserting' }
HsBankAccount >> assertNotClosed [
	self isClosed ifTrue: [self raiseAccountNotOpen: self id].
	
]

{ #category : 'asserting' }
HsBankAccount >> assertWithinOverdraftLimit: newChange [
	( self balance + newChange <  self overdraftLimit negated ) ifTrue: [self raiseInsufficientFunds: self id limit: self overdraftLimit].
]

{ #category : 'accessing' }
HsBankAccount >> balance [

	^ balance
]

{ #category : 'mutating' }
HsBankAccount >> close [
	self mutate: HsBankAccountClosed using: [ :ev | ev setClosedTimestamp ]
]

{ #category : 'accessing' }
HsBankAccount >> closedTimestamp [

	^ closedTimestamp
]

{ #category : 'accessing' }
HsBankAccount >> emailAddress [

	^ emailAddress
]

{ #category : 'accessing' }
HsBankAccount >> emailAddress: anObject [

	emailAddress := anObject
]

{ #category : 'initializing' }
HsBankAccount >> initialize [
	super initialize.
	balance := 0.
	overdraftLimit := 0.
]

{ #category : 'testing' }
HsBankAccount >> isClosed [

	^ self closedTimestamp notNil
]

{ #category : 'factory' }
HsBankAccount >> modelCreatedEventClass [
	^ HsBankAccountOpened
]

{ #category : 'accessing' }
HsBankAccount >> name [

	^ name
]

{ #category : 'accessing' }
HsBankAccount >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
HsBankAccount >> overdraftLimit [

	^ overdraftLimit
]

{ #category : 'mutating' }
HsBankAccount >> overdraftLimit: newLimit [
	self mutate: HsBankAccountOverdraftLimitChanged using: [ :ev | ev value: newLimit abs]
]

{ #category : 'errors' }
HsBankAccount >> raiseAccountNotOpen: anAccountId [
	(HsBankAccountNotOpen accountId: anAccountId) raise
]

{ #category : 'errors' }
HsBankAccount >> raiseInsufficientFunds: anAccountId limit: anOverdraftLimit [
	(HsBankAccountInsufficientFunds accountId: anAccountId)
		overdraftLimit: anOverdraftLimit;
		raise
]
