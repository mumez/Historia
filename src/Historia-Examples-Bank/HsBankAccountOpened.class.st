Class {
	#name : 'HsBankAccountOpened',
	#superclass : 'HsModelCreated',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'accessing' }
HsBankAccountOpened class >> typeName [
	^ #ba:accountOpened
]

{ #category : 'accessing' }
HsBankAccountOpened >> emailAddress [
	^ self argsAt: 'emailAddress'
]

{ #category : 'accessing' }
HsBankAccountOpened >> emailAddress: aString [
	self argsAt: 'emailAddress' put: aString
]

{ #category : 'accessing' }
HsBankAccountOpened >> name [
	^ self argsAt: 'name'
]

{ #category : 'accessing' }
HsBankAccountOpened >> name: aString [
	self argsAt: 'name' put: aString
]
