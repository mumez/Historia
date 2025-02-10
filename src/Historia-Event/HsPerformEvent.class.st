Class {
	#name : 'HsPerformEvent',
	#superclass : 'HsCommandEvent',
	#instVars : [
		'selector'
	],
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'instance creation' }
HsPerformEvent class >> targetId: id selector: selector [
	^self new targetId: id selector: selector
]

{ #category : 'instance creation' }
HsPerformEvent class >> targetId: id selector: selector arguments: args [
	^self new targetId: id selector: selector arguments: args
		
]

{ #category : 'accessing' }
HsPerformEvent class >> typeName [
	^ #_pfm
]

{ #category : 'actions' }
HsPerformEvent >> applyTo: target [
	^ target perform: self selector asSymbol withArguments: self arguments
]

{ #category : 'factory' }
HsPerformEvent >> argumentsCollectionClass [
	^ Array new
]

{ #category : 'serializing' }
HsPerformEvent >> asCompactDictionary [
	| data |
	data := super asCompactDictionary.
	self selector ifNotNil: [ :val | data at: 'sele' put: val ].
	^ data
]

{ #category : 'actions' }
HsPerformEvent >> executeOn: modelSpace [
	| target |
	target := modelSpace modelAt: self targetId ifAbsent: [^ self]. 
	target perform: self selector asSymbol withArguments: self arguments.
	modelSpace handleSinked: self
]

{ #category : 'printing' }
HsPerformEvent >> printAttributesOn: aStream [

	super printAttributesOn: aStream.
	aStream
		nextPutAll: ' selector:';
		nextPutAll: self selector asString.
	aStream
		nextPutAll: ' arguments:';
		nextPutAll: self arguments asString
]

{ #category : 'reading' }
HsPerformEvent >> readFromCompactDictionary: aDictionary [
	super readFromCompactDictionary: aDictionary.
	aDictionary at: #sele ifPresent: [:val | self selector: val asSymbol ]
	
]

{ #category : 'accessing' }
HsPerformEvent >> selector [
	^selector
]

{ #category : 'accessing' }
HsPerformEvent >> selector: aSymbol [
	selector := aSymbol
]

{ #category : 'initialize-release' }
HsPerformEvent >> targetId: tid selector: aSymbol [
	^ self targetId: tid selector: aSymbol arguments: #()
]

{ #category : 'initialize-release' }
HsPerformEvent >> targetId: aTargetId selector: aSelector arguments: arguments [
	self targetId: aTargetId.
	self selector: aSelector.
	self arguments: arguments
]
