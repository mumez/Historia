Class {
	#name : 'HsEventJournalStorage',
	#superclass : 'Object',
	#instVars : [
		'eventStream',
		'spaceId',
		'settings'
	],
	#category : 'Historia-Storage',
	#package : 'Historia-Storage'
}

{ #category : 'instance creation' }
HsEventJournalStorage class >> spaceId: aSpaceId [
	^ self new
		  spaceId: aSpaceId;
		  yourself
]

{ #category : 'actions' }
HsEventJournalStorage >> allEvents [
	^ self streamIterator collect: [ :entry |
		  HsEvent fromStreamEntry: entry ]
]

{ #category : 'accessing' }
HsEventJournalStorage >> bootstrapEventVersion [
	^ RsStreamMessageId zero
]

{ #category : 'private' }
HsEventJournalStorage >> buildCodecAndEventData: anEvent [
	anEvent cleanBeforeSend.
	^ {
		  (#data -> (anEvent serializedOn: self codec)).
		  (#codec -> self codecType) }
]

{ #category : 'factory' }
HsEventJournalStorage >> codec [
	^ HsCodec type: self codecType 
]

{ #category : 'accessing' }
HsEventJournalStorage >> codecType [
	^ self settings eventCodec
]

{ #category : 'actions' }
HsEventJournalStorage >> deleteEventsFrom: fromMessageId [
	| eventIds |
	eventIds := (self latestEventsFrom: fromMessageId) collect: [:each | each id].
	^ self streamIterator deleteAtIds: eventIds 
]

{ #category : 'accessing' }
HsEventJournalStorage >> eventStream [
	^ eventStream ifNil: [ eventStream := HsUtils default newEventStreamNamed: self spaceId ]
]

{ #category : 'actions' }
HsEventJournalStorage >> eventsFrom: fromMessageId to: toMessageId [
	| events |
	events := OrderedCollection new.
	(self streamIteratorNextFrom: fromMessageId)
		do: [ :entry | HsEvent fromStreamEntry: entry ]
		whileFalse: [ :ents :ent | ent id > toMessageId ].
	^ events
]

{ #category : 'accessing' }
HsEventJournalStorage >> firstEventVersion [
	^ self eventStream first
		  ifNotNil: [ :first | first id ]
]

{ #category : 'initialize-release' }
HsEventJournalStorage >> initEventStream [
	eventStream := nil
]

{ #category : 'initialize-release' }
HsEventJournalStorage >> initialize [
	self initEventStream 
]

{ #category : 'accessing' }
HsEventJournalStorage >> lastEventVersion [
	^ self eventStream last
		  ifNil: [ self bootstrapEventVersion ]
		  ifNotNil: [ :last | last id ]
]

{ #category : 'actions' }
HsEventJournalStorage >> latestEventsFrom: fromMessageId [
	^ (self streamIteratorNextFrom: fromMessageId) collect: [ :entry |
		  HsEvent fromStreamEntry: entry ]
]

{ #category : 'actions' }
HsEventJournalStorage >> markBadEventAt: aMessageId [ 
	| event deletedCount |
	event := self eventStream contentAt: aMessageId.
	event ifNil: [ ^ self ].
	deletedCount := self eventStream deleteAt: aMessageId.
	^ deletedCount = 1 
]

{ #category : 'actions' }
HsEventJournalStorage >> putEvent: anEvent [
	^ self eventStream nextPutAssociations: (self buildCodecAndEventData: anEvent)
]

{ #category : 'actions' }
HsEventJournalStorage >> replayableEventsFrom: possibleFromEventVersion [
	| fromEventVersion events |
	fromEventVersion := possibleFromEventVersion ifNil: [
		                    self bootstrapEventVersion ].
	events := self latestEventsFrom: fromEventVersion.
	^ events select: [ :c | c isReplayable ]
]

{ #category : 'actions' }
HsEventJournalStorage >> replayableEventsFrom: possibleFromEventVersion to: possibleToEventVersion [
	| fromEventVersion toEventVersion events |
	fromEventVersion := possibleFromEventVersion ifNil: [
		                    self bootstrapEventVersion ].
	toEventVersion := possibleFromEventVersion ifNil: [
		                    fromEventVersion ].
	events := self eventsFrom: fromEventVersion to: toEventVersion.
	^ events select: [ :c | c isReplayable ]
]

{ #category : 'initialize-release' }
HsEventJournalStorage >> reset [
	self initEventStream 
	
]

{ #category : 'accessing' }
HsEventJournalStorage >> settings [
	^ settings ifNil: [ settings := HsSettings defaultCopied ]
]

{ #category : 'accessing' }
HsEventJournalStorage >> settings: anObject [

	settings := anObject
]

{ #category : 'accessing' }
HsEventJournalStorage >> spaceId [
	^ spaceId
]

{ #category : 'accessing' }
HsEventJournalStorage >> spaceId: anObject [

	spaceId := anObject
]

{ #category : 'accessing' }
HsEventJournalStorage >> streamIterator [
	^ self eventStream iterator
]

{ #category : 'accessing' }
HsEventJournalStorage >> streamIteratorNextFrom: fromId [
	^ self eventStream iteratorNextFrom: fromId
]
