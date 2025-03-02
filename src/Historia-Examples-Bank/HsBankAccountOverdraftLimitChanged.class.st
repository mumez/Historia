Class {
	#name : 'HsBankAccountOverdraftLimitChanged',
	#superclass : 'HsValueChanged',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'accessing' }
HsBankAccountOverdraftLimitChanged class >> typeName [
	^ #ba:overdraftLimitChanged
]

{ #category : 'mutating' }
HsBankAccountOverdraftLimitChanged >> applyTo: target [
	target applyOverdraftLimit: self value
]
