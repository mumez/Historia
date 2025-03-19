Class {
	#name : 'HsBankAccountInsufficientFunds',
	#superclass : 'HsBankAccountError',
	#instVars : [
		'overdraftLimit'
	],
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'accessing' }
HsBankAccountInsufficientFunds >> overdraftLimit [

	^ overdraftLimit
]

{ #category : 'accessing' }
HsBankAccountInsufficientFunds >> overdraftLimit: anObject [

	overdraftLimit := anObject
]
