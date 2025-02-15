Class {
	#name : 'HsBankAccountOverdraftLimitChanged',
	#superclass : 'HsValueChanged',
	#category : 'Historia-Examples-Bank',
	#package : 'Historia-Examples-Bank'
}

{ #category : 'mutating' }
HsBankAccountOverdraftLimitChanged >> applyTo: target [
	target applyOverdraftLimit: self value
]
