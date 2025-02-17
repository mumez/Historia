Class {
	#name : 'HsBankAccountNotExist',
	#superclass : 'Error',
	#instVars : [
		'accountId'
	],
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'instance creation' }
HsBankAccountNotExist class >> accountId: accountId [
	^ self new
		  accountId: accountId;
		  yourself
]

{ #category : 'accessing' }
HsBankAccountNotExist >> accountId [

	^ accountId
]

{ #category : 'accessing' }
HsBankAccountNotExist >> accountId: anObject [

	accountId := anObject
]
