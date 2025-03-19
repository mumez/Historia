Class {
	#name : 'HsBankAccountError',
	#superclass : 'Error',
	#instVars : [
		'accountId'
	],
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'instance creation' }
HsBankAccountError class >> accountId: accountId [
	^ self new
		  accountId: accountId;
		  yourself
]

{ #category : 'accessing' }
HsBankAccountError >> accountId [

	^ accountId
]

{ #category : 'accessing' }
HsBankAccountError >> accountId: anObject [

	accountId := anObject
]
