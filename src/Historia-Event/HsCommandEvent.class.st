Class {
	#name : 'HsCommandEvent',
	#superclass : 'HsEvent',
	#instVars : [
		'targetIds'
	],
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'testing' }
HsCommandEvent class >> isCommand [
	^true
]

{ #category : 'instance creation' }
HsCommandEvent class >> originatorId: originatorId targetId: targetId [
	^ (self originatorId: originatorId) targetId: targetId;
		  yourself
]

{ #category : 'accessing' }
HsCommandEvent class >> typeName [
	^ #_comm
]

{ #category : 'serializing' }
HsCommandEvent >> asCompactDictionary [
	| data |
	data := super asCompactDictionary.
	self targetIds ifNotEmpty: [ :val | data at: 'tids' put: val ].
	^ data
]

{ #category : 'actions' }
HsCommandEvent >> executeOn: modelSpace [
	| targetModel |
	targetModel := modelSpace modelAt: self targetId ifAbsent: [
		               self logger warn:
			               '#executeOn: no target on modelSpace: '
			               , self targetId asString.
		               ^ self ].
	targetModel handleSinked: self.
	super executeOn: modelSpace.
]

{ #category : 'comparing' }
HsCommandEvent >> hash [
	^ (super hash bitXor: self targetIds hash) bitXor: self arguments hash

]

{ #category : 'printing' }
HsCommandEvent >> printAttributesOn: aStream [

	super printAttributesOn: aStream.
	aStream
		nextPutAll: ' targetIds:';
		nextPutAll: self targetIds asString
]

{ #category : 'reading' }
HsCommandEvent >> readFromCompactDictionary: aDictionary [
	super readFromCompactDictionary: aDictionary.
	aDictionary at: #tids ifPresent: [:val | self targetIds: val ]
	
]

{ #category : 'accessing' }
HsCommandEvent >> targetId [

	^ self targetIds first
]

{ #category : 'accessing' }
HsCommandEvent >> targetId: anObject [

	self targetIds: { anObject }
]

{ #category : 'accessing' }
HsCommandEvent >> targetIds [

	^ targetIds
]

{ #category : 'accessing' }
HsCommandEvent >> targetIds: anObject [

	targetIds := anObject
]
