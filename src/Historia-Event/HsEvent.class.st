Class {
	#name : 'HsEvent',
	#superclass : 'Object',
	#instVars : [
		'args',
		'eventId',
		'undoArgs',
		'originatorId',
		'userId',
		'context',
		'streamEntry'
	],
	#classVars : [
		'EventClasses'
	],
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'instance creation' }
HsEvent class >> fromStreamEntry: streamEntry [
	| eventData |
	eventData := HsCodec materializeCodecAndData:
		             streamEntry fieldsAndValues.
	^ (self id: streamEntry id data: eventData)
		  streamEntry: streamEntry;
		  yourself
]

{ #category : 'instance creation' }
HsEvent class >> id: eventId [
	^ self new
		  eventId: eventId;
		  yourself
]

{ #category : 'instance creation' }
HsEvent class >> id: eventId data: eventData [
	| type eventClass |
	type := eventData at: #tp ifAbsent: [ self name ].
	eventClass := EventClasses at: type ifAbsent: [ self ].
	^ (eventClass id: eventId) readFromCompactDictionary: eventData
]

{ #category : 'class initialization' }
HsEvent class >> initialize [
	EventClasses := Dictionary new.
	self register.
	self allSubclassesDo: [ :each | each register ]
]

{ #category : 'instance creation' }
HsEvent class >> originatorId: originatorId [
	^ self new
		  originatorId: originatorId;
		  yourself
]

{ #category : 'instance creation' }
HsEvent class >> originatorId: originatorId targetId: targetId [
	^ self originatorId: originatorId
]

{ #category : 'registering' }
HsEvent class >> register [
	EventClasses at: self typeName put: self
]

{ #category : 'accessing' }
HsEvent class >> typeName [
	^ #_evt
]

{ #category : 'comparing' }
HsEvent >> = aEventRecord [
	aEventRecord ifNil: [^ false].	
	self typeName == aEventRecord typeName ifFalse: [^ false].
	self eventId == aEventRecord eventId ifFalse: [^ false].
	^ true
]

{ #category : 'mutating' }
HsEvent >> applyTo: target [
	self logger warn: 'Abstract HsEvent applyTo: called! You may forget to register new event class!'
]

{ #category : 'accessing' }
HsEvent >> argsAt: key [
	^ self arguments at: key ifAbsent: []
]

{ #category : 'accessing' }
HsEvent >> argsAt: key ifAbsent: aBlock [
	^ self arguments at: key ifAbsent: aBlock
]

{ #category : 'accessing' }
HsEvent >> argsAt: key put: value [
	^ self arguments at: key put: value
]

{ #category : 'accessing' }
HsEvent >> arguments [
	args ifNil: [args := self argumentsCollectionClass new].
	^ args
]

{ #category : 'accessing' }
HsEvent >> arguments: arguments [
	args := arguments
]

{ #category : 'factory' }
HsEvent >> argumentsCollectionClass [
	^ Dictionary
]

{ #category : 'converting' }
HsEvent >> asAnnouncement [
	^ HsEventAnnouncement on: self
]

{ #category : 'serializing' }
HsEvent >> asCompactDictionary [
	| data |
	data := Dictionary new.
	self typeName ifNotNil: [ :val | data at: 'tp' put: val ].
	context ifNotNil: [ :val | data at: 'ctx' put: val ].
	args ifNotNil: [ :val | data at: 'args' put: val ].
	undoArgs ifNotNil: [ :val | data at: 'uargs' put: val ].
	originatorId ifNotNil: [ :val | data at: 'oid' put: val ].
	userId ifNotNil: [ :val | data at: 'uid' put: val ].
	^ data
]

{ #category : 'callback' }
HsEvent >> cleanBeforeSend [
	
]

{ #category : 'accessing' }
HsEvent >> context [
	context ifNil: [context := Dictionary new].
	^ context
]

{ #category : 'accessing' }
HsEvent >> context: anObject [

	context := anObject
]

{ #category : 'accessing' }
HsEvent >> contextAt: key [
	^ self context at: key ifAbsent: []
]

{ #category : 'accessing' }
HsEvent >> contextAt: key ifAbsent: aBlock [
	^ self context at: key ifAbsent: aBlock
]

{ #category : 'accessing' }
HsEvent >> contextAt: key put: value [
	^ self context at: key put: value
]

{ #category : 'accessing' }
HsEvent >> eventId [
	^ eventId
]

{ #category : 'accessing' }
HsEvent >> eventId: anInteger [
	eventId := anInteger
]

{ #category : 'actions' }
HsEvent >> executeOn: modelSpace [
	modelSpace handleSinked: self
]

{ #category : 'testing' }
HsEvent >> hasArguments [
	^ args notNil and: [ args notEmpty ]
]

{ #category : 'comparing' }
HsEvent >> hash [
	^ self typeName hash bitXor: self eventId hash
]

{ #category : 'testing' }
HsEvent >> isEvent [
	^true
]

{ #category : 'testing' }
HsEvent >> isNotification [
	^ false
]

{ #category : 'testing' }
HsEvent >> isReplayable [
	^ true
]

{ #category : 'accessing' }
HsEvent >> logger [
	^ HsLogger default
]

{ #category : 'accessing' }
HsEvent >> originatorId [

	^ originatorId
]

{ #category : 'accessing' }
HsEvent >> originatorId: anObject [

	originatorId := anObject
]

{ #category : 'printing' }
HsEvent >> printAttributesOn: aStream [

	aStream
		nextPutAll: '#';
		nextPutAll: self eventId asString;
		nextPutAll: ': '.
	aStream nextPutAll: self typeName.
]

{ #category : 'printing' }
HsEvent >> printOn: aStream [

	aStream nextPutAll: '['.
	self printAttributesOn: aStream.
	aStream nextPutAll: ']'
]

{ #category : 'reading' }
HsEvent >> readFromCompactDictionary: aDictionary [
	aDictionary at: #ctx ifPresent: [:val | self context: val ].
	aDictionary at: #args ifPresent: [:val | self arguments: val ].
	aDictionary at: #uargs ifPresent: [:val | self undoArgs: val ].
	aDictionary at: #oid ifPresent: [:val | self originatorId: val ].
	aDictionary at: #uid ifPresent: [:val | self userId: val ]
	
]

{ #category : 'serializing' }
HsEvent >> serializedOn: anEventCodec [
	^ anEventCodec serialize: self asCompactDictionary
]

{ #category : 'testing' }
HsEvent >> shouldExecuteOn: modelSpace [
	"override"
	| isSameOrigin isOldVersion |
	isSameOrigin := self originatorId = modelSpace originatorId.
	isSameOrigin ifTrue: [ ^ false ].
	isOldVersion := modelSpace lastExecutedVersion notNil and: [self version < modelSpace lastExecutedVersion].
	isOldVersion ifTrue: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
HsEvent >> streamEntry [

	^ streamEntry
]

{ #category : 'accessing' }
HsEvent >> streamEntry: anObject [

	streamEntry := anObject
]

{ #category : 'accessing' }
HsEvent >> streamEntryId [
	^ self streamEntry ifNotNil: [ :ent | ent id ]
]

{ #category : 'accessing' }
HsEvent >> typeName [
	^ self class typeName
	
	
]

{ #category : 'accessing' }
HsEvent >> undoArgs [
	undoArgs ifNil: [undoArgs := self argumentsCollectionClass new].
	^ undoArgs 
]

{ #category : 'accessing' }
HsEvent >> undoArgs: dic [
	undoArgs := dic
]

{ #category : 'accessing' }
HsEvent >> undoArgsAt: key [
	^ self undoArgs at: key ifAbsent: []
]

{ #category : 'accessing' }
HsEvent >> undoArgsAt: key put: value [
	^ self undoArgs at: key put: value
]

{ #category : 'accessing' }
HsEvent >> userId [
	^ userId
]

{ #category : 'accessing' }
HsEvent >> userId: aUserId [
	userId := aUserId
]

{ #category : 'accessing' }
HsEvent >> version [
	^ self streamEntryId 
]
