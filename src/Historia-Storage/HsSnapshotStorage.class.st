Class {
	#name : 'HsSnapshotStorage',
	#superclass : 'Object',
	#instVars : [
		'spaceId',
		'settings',
		'stick',
		'eventStream'
	],
	#category : 'Historia-Storage',
	#package : 'Historia-Storage'
}

{ #category : 'instance creation' }
HsSnapshotStorage class >> on: aModelSpace [
	^ (self spaceId: aModelSpace spaceId) settings: aModelSpace settings; yourself
	
]

{ #category : 'instance creation' }
HsSnapshotStorage class >> spaceId: aSpaceId [
	^ self new
		  spaceId: aSpaceId;
		  yourself
]

{ #category : 'versions' }
HsSnapshotStorage >> addSnapshotVersion: versionString [
	self stick endpoint rPush: self versionsListName value: versionString
]

{ #category : 'factory' }
HsSnapshotStorage >> codec [
	^ HsCodec type: self codecType 
]

{ #category : 'accessing' }
HsSnapshotStorage >> codecType [
	^ self settings snapshotCodec 
]

{ #category : 'releasing' }
HsSnapshotStorage >> destroy [
	self eventStream beEmptyAndReset.
	self stick endpoint del: {self versionsListName}.
]

{ #category : 'accessing' }
HsSnapshotStorage >> eventStream [
	^ eventStream ifNil: [ eventStream := HsUtils default newEventStreamNamed: self streamName ]
]

{ #category : 'versions' }
HsSnapshotStorage >> existsRecentSnapshotVersion: versionString [
	| position |
	position := self stick endpoint lPosBackward: self versionsListName value: versionString maxlen: self settings snapshotVersionsTakeChunkSize.
	^ position notNil
]

{ #category : 'actions' }
HsSnapshotStorage >> lastSnapshot [
	| entry |
	entry := self eventStream last.
	^ self materializeSnapshotFromEntry: entry
]

{ #category : 'versions' }
HsSnapshotStorage >> lastSnapshotVersion [
	| lasts |
	lasts := self stick endpoint lRange: self versionsListName start: -1 end: -1.
	^ lasts ifEmpty:[] ifNotEmpty: [:vals | vals first]. 
]

{ #category : 'versions' }
HsSnapshotStorage >> listSnapshotVersions [
	^ self stick endpoint lRange: self versionsListName start: 0 end: -1 
]

{ #category : 'versions' }
HsSnapshotStorage >> listSnapshotVersionsReversedFromLast: count [
	^ (self stick endpoint lRange: self versionsListName start: count negated end: -1) reversed 
]

{ #category : 'private' }
HsSnapshotStorage >> materializeSnapshotFromEntry: aStreamEntry [
	| keyAndData snapshotBinary domainModels |
	aStreamEntry ifNil: [ ^ nil ].
	keyAndData := aStreamEntry content.
	keyAndData key ~= self codecType ifTrue: [ ^ nil ].
	snapshotBinary := keyAndData value.
	domainModels := self codec materialize: snapshotBinary.
	^ {
		  aStreamEntry id.
		  domainModels }
]

{ #category : 'versions' }
HsSnapshotStorage >> recentSnapshotVersionFrom: version [
	| startIdx chunkSize |
	startIdx := 1.
	chunkSize := self settings snapshotVersionsTakeChunkSize.
	[ | chunk found |
	chunk := self stick endpoint
		         lRange: self versionsListName
		         start: (startIdx + chunkSize - 1) negated
		         end: startIdx negated.
	found := chunk reversed
		         detect: [ :each | each asStreamMessageId < version asStreamMessageId ]
		         ifNone: [  ].
	found ifNotNil: [ ^ found ].
	startIdx := startIdx + chunkSize.
	chunk size = chunkSize ] whileTrue.
	^ nil
]

{ #category : 'serialize/materialize' }
HsSnapshotStorage >> serialize: domainModels [
	^ self codec serialize: domainModels 
]

{ #category : 'accessing' }
HsSnapshotStorage >> settings [

	^ settings ifNil: [ settings := HsSettings defaultCopied ]
]

{ #category : 'accessing' }
HsSnapshotStorage >> settings: anObject [

	settings := anObject
]

{ #category : 'actions' }
HsSnapshotStorage >> snapshotAt: snapshotVersion [
	| entry |
	entry := self eventStream contentAt: snapshotVersion.
	^ self materializeSnapshotFromEntry: entry
]

{ #category : 'actions' }
HsSnapshotStorage >> snapshotAt: snapshotVersion put: domainModels [
	| bytes messageId |
	bytes := self codec serialize: domainModels.
	messageId := self eventStream nextPutAssociations: { (self codecType -> bytes) } at: snapshotVersion.
	self addSnapshotVersion: messageId.
	^ {
		  snapshotVersion.
		  bytes }
]

{ #category : 'accessing' }
HsSnapshotStorage >> spaceId [

	^ spaceId
]

{ #category : 'accessing' }
HsSnapshotStorage >> spaceId: anObject [

	spaceId := anObject
]

{ #category : 'accessing' }
HsSnapshotStorage >> stick [
	^ self eventStream stick
]

{ #category : 'accessing' }
HsSnapshotStorage >> streamName [
	^ self spaceId, '__snapshot'
]

{ #category : 'accessing' }
HsSnapshotStorage >> versionsListName [
	 ^ self settings snapshotVersionListPrefix, self spaceId
]
