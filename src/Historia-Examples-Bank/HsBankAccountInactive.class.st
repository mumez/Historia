Class {
	#name : 'HsBankAccountInactive',
	#superclass : 'HsBankAccountError',
	#instVars : [
		'closedTimestamp'
	],
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'accessing' }
HsBankAccountInactive >> closedTimestamp [

	^ closedTimestamp
]

{ #category : 'accessing' }
HsBankAccountInactive >> closedTimestamp: anObject [

	closedTimestamp := anObject
]
