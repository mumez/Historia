Class {
	#name : 'HsBankOpened',
	#superclass : 'HsModelCreated',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'private' }
HsBankOpened >> createInstanceOf: modelClass [
	| inst |
	inst := super createInstanceOf: modelClass.
	inst name: self name.
	inst emailAddress: self emailAddress.
	^ inst
]

{ #category : 'accessing' }
HsBankOpened >> emailAddress [
	^ self argsAt: 'emailAddress'
]

{ #category : 'accessing' }
HsBankOpened >> emailAddress: aString [
	self argsAt: 'emailAddress' put: aString
]

{ #category : 'accessing' }
HsBankOpened >> name [
	^ self argsAt: 'name'
]

{ #category : 'accessing' }
HsBankOpened >> name: aString [
	self argsAt: 'name' put: aString
]
