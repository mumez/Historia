Class {
	#name : 'HsBankAccountClosed',
	#superclass : 'HsValueChanged',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'accessing' }
HsBankAccountClosed class >> typeName [
	^ #ba:accountClosed
]

{ #category : 'mutating' }
HsBankAccountClosed >> applyTo: target [
	target applyClosedTimestamp: self value
]

{ #category : 'actions' }
HsBankAccountClosed >> setClosedTimestamp [
	self value: DateAndTime current
]
