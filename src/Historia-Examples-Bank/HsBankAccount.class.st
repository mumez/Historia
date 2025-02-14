Class {
	#name : 'HsBankAccount',
	#superclass : 'HsModel',
	#instVars : [
		'name',
		'emailAddress',
		'balance',
		'isClosed',
		'overdraftLimit'
	],
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'accessing' }
HsBankAccount >> balance [

	^ balance
]

{ #category : 'accessing' }
HsBankAccount >> balance: anObject [

	balance := anObject
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
	isClosed := false.
	overdraftLimit := 0.
]

{ #category : 'accessing' }
HsBankAccount >> isClosed [

	^ isClosed
]

{ #category : 'accessing' }
HsBankAccount >> isClosed: anObject [

	isClosed := anObject
]

{ #category : 'factory' }
HsBankAccount >> modelCreatedEventClass [
	^ HsBankOpened
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

{ #category : 'accessing' }
HsBankAccount >> overdraftLimit: anObject [

	overdraftLimit := anObject
]
