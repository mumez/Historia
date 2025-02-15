Class {
	#name : 'HsBankAccountClosed',
	#superclass : 'HsValueChanged',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'mutating' }
HsBankAccountClosed >> applyTo: target [
	target applyClosedTimestamp: self value
]

{ #category : 'actions' }
HsBankAccountClosed >> setClosedTimestamp [
	self value: DateAndTime current
]
