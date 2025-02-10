Class {
	#name : 'HsValueAdded',
	#superclass : 'HsCommandEvent',
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'accessing' }
HsValueAdded class >> typeName [
	^ #valueAdded
]

{ #category : 'mutating' }
HsValueAdded >> applyTo: target [
	target applyAdd: self value
]

{ #category : 'accessing' }
HsValueAdded >> value [
	^ self argsAt: 'value'
]

{ #category : 'accessing' }
HsValueAdded >> value: newValue [

	self argsAt: 'value' put: newValue
]
