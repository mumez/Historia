Class {
	#name : 'HsValueRemoved',
	#superclass : 'HsCommandEvent',
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'accessinv' }
HsValueRemoved class >> typeName [
	^ #valueRemoved
]

{ #category : 'mutating' }
HsValueRemoved >> applyTo: target [
	target applyRemove: self value
]

{ #category : 'accessing' }
HsValueRemoved >> value [
	^ self argsAt: 'value'
]

{ #category : 'accessing' }
HsValueRemoved >> value: newValue [

	self argsAt: 'value' put: newValue
]
