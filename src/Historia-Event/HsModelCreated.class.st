Class {
	#name : 'HsModelCreated',
	#superclass : 'HsCommandEvent',
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'accessing' }
HsModelCreated class >> typeName [
	^ #modelCreated
]

{ #category : 'mutating' }
HsModelCreated >> applyTo: targetModel [
	targetModel modelSpace putModel: targetModel
]

{ #category : 'accessing' }
HsModelCreated >> className [
	^ self argsAt: 'className'
]

{ #category : 'accessing' }
HsModelCreated >> className: newName [

	self argsAt: 'className' put: newName
]

{ #category : 'private' }
HsModelCreated >> createInstanceOf: modelClass [
	^ modelClass id: self modelId
]

{ #category : 'actions' }
HsModelCreated >> executeOn: modelSpace [
	| modelClass |
	modelClass := modelSpace executionContextClassAt: self className ifAbsent: [].
	modelClass ifNotNil: [ modelSpace putModel: (self createInstanceOf: modelClass) ].
	modelSpace handleSinked: self
]

{ #category : 'accessing' }
HsModelCreated >> modelId [
	^ self argsAt: 'modelId'
]

{ #category : 'accessing' }
HsModelCreated >> modelId: anId [

	self argsAt: 'modelId' put: anId
]
