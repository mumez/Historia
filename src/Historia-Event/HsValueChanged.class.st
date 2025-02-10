Class {
	#name : 'HsValueChanged',
	#superclass : 'HsCommandEvent',
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'accessing' }
HsValueChanged class >> typeName [
	^ #valueChanged
]

{ #category : 'mutating' }
HsValueChanged >> applyTo: target [
	target applyValue: self value
]

{ #category : 'accessing' }
HsValueChanged >> value [
	^ self argsAt: 'value'
]

{ #category : 'accessing' }
HsValueChanged >> value: newValue [

	self argsAt: 'value' put: newValue
]
