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
HsModelCreated >> applyInitializerArgumentsTo: targetModel [
	self initializerArguments keysAndValuesDo: [ :k :v |
		[ targetModel perform: k asSymbol asMutator with: v ]
			on: MessageNotUnderstood
			do: [ :ex | self logger warn: ex printString ] ]
]

{ #category : 'mutating' }
HsModelCreated >> applyTo: targetModel [
	targetModel modelSpace putModel: targetModel.
	self applyInitializerArgumentsTo: targetModel.
]

{ #category : 'accessing' }
HsModelCreated >> className [
	^ self argsAt: '_className'
]

{ #category : 'accessing' }
HsModelCreated >> className: newName [

	self argsAt: '_className' put: newName
]

{ #category : 'private' }
HsModelCreated >> createInstanceOf: modelClass [
	| inst |
	inst := modelClass id: self modelId.
	inst initWithArguments: self initializerArguments.
	^ inst
]

{ #category : 'actions' }
HsModelCreated >> executeOn: modelSpace [
	| modelClass |
	modelClass := modelSpace executionContextClassAt: self className ifAbsent: [].
	modelClass ifNotNil: [ 
			modelSpace putModel: (self createInstanceOf: modelClass) 
	].
	modelSpace handleSinked: self
]

{ #category : 'accessing' }
HsModelCreated >> initializerArguments [
	| keys initializerArgs |
	keys := self arguments keys reject: [ :each | each beginsWith: '_' ].
	initializerArgs := self argumentsCollectionClass new.
	keys do: [ :each |
		self argsAt: each ifPresent: [:val | initializerArgs at: each put: val]	
	].
	^ initializerArgs
]

{ #category : 'accessing' }
HsModelCreated >> modelId [
	^ self argsAt: '_modelId'
]

{ #category : 'accessing' }
HsModelCreated >> modelId: anId [

	self argsAt: '_modelId' put: anId
]
