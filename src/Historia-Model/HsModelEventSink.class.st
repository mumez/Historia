Class {
	#name : 'HsModelEventSink',
	#superclass : 'Object',
	#instVars : [
		'eventPuller',
		'lastExecutedVersion',
		'lastLoadedSnapshotVersion',
		'models',
		'settings',
		'spaceId',
		'eventJournalStorage',
		'snapshotStorage',
		'snapshotTaker',
		'originatorId'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'utilities' }
HsModelEventSink class >> initializeEvents [
	HsEvent initialize
]

{ #category : 'instance creation' }
HsModelEventSink class >> spaceId: aSpaceId [
	^ self new
		  spaceId: aSpaceId;
		  yourself
]

{ #category : 'initializing' }
HsModelEventSink >> catchup [
	| snapVersion |
	snapVersion := self lastSnapshotVersion.
	self setupFrom: snapVersion.
]

{ #category : 'notifying' }
HsModelEventSink >> defaultNotifierModel [
	^ self modelAt: HsDefaultNotifierModel defaultId ifAbsentPut: [ HsDefaultNotifierModel on: self ]
]

{ #category : 'defaults' }
HsModelEventSink >> defaultSettings [
	^ HsSettings defaultCopied
]

{ #category : 'actions-model' }
HsModelEventSink >> deleteModel: aModel [
	aModel modelSpace: self.
	self deleteModelAt: aModel id
]

{ #category : 'accessing-models' }
HsModelEventSink >> deleteModelAt: modelId [
	^ self models removeKey: modelId ifAbsent: [  ]
]

{ #category : 'accessing' }
HsModelEventSink >> eventJournalStorage [
	^ eventJournalStorage ifNil: [
		  eventJournalStorage := (self eventJournalStorageClass spaceId:
				                          self spaceId)
			                         settings: self settings;
			                         yourself ]
]

{ #category : 'factory' }
HsModelEventSink >> eventJournalStorageClass [
	^ HsEventJournalStorage
]

{ #category : 'accessing' }
HsModelEventSink >> eventPuller [

	^ eventPuller ifNil: [ eventPuller := self eventPullerClass on: self ]
]

{ #category : 'accessing' }
HsModelEventSink >> eventPuller: anObject [

	eventPuller := anObject
]

{ #category : 'factory' }
HsModelEventSink >> eventPullerClass [
	^ HsEventPuller
]

{ #category : 'accessing-events' }
HsModelEventSink >> eventVersionsReversedFrom: version limit: limit [
	^ self eventJournalStorage eventVersionsReversedFrom: version limit: limit
]

{ #category : 'accessing-events' }
HsModelEventSink >> eventVersionsReversedFromLast: limit [
	^ self eventJournalStorage eventVersionsReversedFromLast: limit
]

{ #category : 'executing-events' }
HsModelEventSink >> execute: anEvent [
	(anEvent shouldExecuteOn: self) ifFalse: [
		self logger info: 'Skip execution of event: ', anEvent asString.
		^self].
	[anEvent executeOn: self]
		on: Exception
		do: [:ex | 
			self settings passServerEventExecutionError ifTrue: [ex pass]. "For debug"
			self handleExecutionError: ex on: anEvent.
			^ nil].
	self postExecuted: anEvent
]

{ #category : 'accessing' }
HsModelEventSink >> executionContextClassAt: className ifAbsent: aBlock [
	^ Smalltalk globals at: className asSymbol ifAbsent: aBlock
]

{ #category : 'private' }
HsModelEventSink >> fixModelsAfterLoadingSnapshot [
	models ifNil: [ ^ self ].
	(models select: [ :each | each isHistoriaModel ]) do: [ :each |
		each modelSpace: self ]
]

{ #category : 'private' }
HsModelEventSink >> generateOriginatorId [
	^ UUID new asString36
]

{ #category : 'time traveling' }
HsModelEventSink >> goTo: toEventVersionId [
	| snapshotVersion |
	snapshotVersion := (self snapshotStorage recentSnapshotVersionFrom: toEventVersionId) ifNil: [].
	self lastExecutedVersion: nil.
	self loadSnapshot: snapshotVersion replayTo: toEventVersionId
]

{ #category : 'error handling' }
HsModelEventSink >> handleExecutionError: anException on: anEvent [
	self logger error: { anException. anEvent }
]

{ #category : 'events' }
HsModelEventSink >> handleSinked: anEvent [
	"override if you wish"
]

{ #category : 'accessing' }
HsModelEventSink >> lastEventVersion [
	^ self eventJournalStorage lastEventVersion
]

{ #category : 'accessing' }
HsModelEventSink >> lastExecutedVersion [

	^ lastExecutedVersion
]

{ #category : 'accessing' }
HsModelEventSink >> lastExecutedVersion: anObject [

	lastExecutedVersion := anObject
]

{ #category : 'accessing' }
HsModelEventSink >> lastLoadedSnapshotVersion [

	^ lastLoadedSnapshotVersion
]

{ #category : 'accessing' }
HsModelEventSink >> lastLoadedSnapshotVersion: anObject [

	lastLoadedSnapshotVersion := anObject
]

{ #category : 'accessing' }
HsModelEventSink >> lastSnapshotVersion [
	^ self snapshotStorage lastSnapshotVersion
]

{ #category : 'snapshotting' }
HsModelEventSink >> loadSnapshot: snapshotVersion [
	| snapArray |
	snapshotVersion ifNil: [ ^ false ].
	snapArray := self snapshotStorage snapshotAt: snapshotVersion.
	self lastLoadedSnapshotVersion: snapArray first.
	self models: snapArray last.
	self fixModelsAfterLoadingSnapshot.
	^ true
]

{ #category : 'snapshotting' }
HsModelEventSink >> loadSnapshot: snapshotVersion replayTo: toEventVersionId [
	| fromVersion |
	fromVersion := (self loadSnapshot: snapshotVersion)
		ifTrue: [snapshotVersion]
		ifFalse: [
			self lastLoadedSnapshotVersion: nil.
			0].
	 self replayFrom: fromVersion to: toEventVersionId 
]

{ #category : 'accessing' }
HsModelEventSink >> logger [
	^ HsLogger default
]

{ #category : 'accessing-models' }
HsModelEventSink >> modelAt: modelId [
	^ self modelAt: modelId ifAbsent: [ ] 
]

{ #category : 'accessing-models' }
HsModelEventSink >> modelAt: modelId ifAbsent: aBlock [
	^ self models at: modelId ifAbsent: aBlock 
]

{ #category : 'accessing-models' }
HsModelEventSink >> modelAt: modelId ifAbsentPut: modelCreationBlock [
	^ self models at: modelId ifAbsentPut: modelCreationBlock 
]

{ #category : 'accessing-models' }
HsModelEventSink >> modelAt: modelId put: aModel [
	^ self models at: modelId put: aModel 
]

{ #category : 'accessing-models' }
HsModelEventSink >> models [
	^ models ifNil: [ models := Dictionary new ]
]

{ #category : 'accessing-models' }
HsModelEventSink >> models: anObject [

	models := anObject
]

{ #category : 'notifying' }
HsModelEventSink >> notify: notificationKind [
	self defaultNotifierModel notify: notificationKind; save
]

{ #category : 'notifying' }
HsModelEventSink >> notify: notificationKind using: aBlock [
	self defaultNotifierModel notify: notificationKind using: aBlock; save
]

{ #category : 'notifying' }
HsModelEventSink >> notify: notificationSymbol withArguments: notificationArgs [
	self defaultNotifierModel notify: notificationSymbol withArguments: notificationArgs; save
]

{ #category : 'accessing' }
HsModelEventSink >> originatorId [

	^ originatorId ifNil: [ originatorId := self generateOriginatorId ]
]

{ #category : 'accessing' }
HsModelEventSink >> originatorId: anObject [

	originatorId := anObject
]

{ #category : 'executing-events' }
HsModelEventSink >> postExecuted: anEvent [
	| eventVersion |
	eventVersion := anEvent version.
	self lastExecutedVersion: eventVersion.
	self snapshotTaker takeIfNeeded: eventVersion
]

{ #category : 'event puller callback' }
HsModelEventSink >> processPulledEvent: anEvent [
	self sinkEvent: anEvent
]

{ #category : 'actions-model' }
HsModelEventSink >> putModel: aModel [
	aModel modelSpace: self.
	self modelAt: aModel id put: aModel
]

{ #category : 'actions-model' }
HsModelEventSink >> putModelOf: modelClass id: modelId [ 
	^ self putModelOf: modelClass id: modelId initializing: [:model | ]
]

{ #category : 'actions-model' }
HsModelEventSink >> putModelOf: modelClass id: modelId initializing: initializerBlock [
	| newModel |
	newModel := modelClass id: modelId.
	newModel instanceCreated: self initializing: initializerBlock.
	^ newModel
]

{ #category : 'actions-model' }
HsModelEventSink >> putModelOf: modelClass id: modelId withArguments: initializerDict [
	^ self
		  putModelOf: modelClass
		  id: modelId
		  initializing: [ :ev | ev mergeArgs: initializerDict asDictionary ]
]

{ #category : 'releasing' }
HsModelEventSink >> releaseStorages [
	self eventPuller destroy.
	self snapshotStorage destroy
]

{ #category : 'replaying' }
HsModelEventSink >> replayFrom: fromEventVersionId [
	(self eventJournalStorage replayableEventsFrom: fromEventVersionId)
		do: [ :each | self execute: each ]
]

{ #category : 'replaying' }
HsModelEventSink >> replayFrom: fromEventVersionId to: toEventVersionId [
	(self eventJournalStorage replayableEventsFrom: fromEventVersionId to: toEventVersionId)
		do: [ :each | self execute: each ]
]

{ #category : 'accessing' }
HsModelEventSink >> settings [
	^ settings ifNil: [ settings := self defaultSettings ]
]

{ #category : 'accessing' }
HsModelEventSink >> settings: anObject [

	settings := anObject
]

{ #category : 'initializing' }
HsModelEventSink >> setupFrom: snapshotVersion [
	self loadSnapshot: snapshotVersion.
	self replayFrom: snapshotVersion.
	self startPullingEventsFromLastExecuted
]

{ #category : 'events' }
HsModelEventSink >> sinkEvent: anEvent [
	self execute: anEvent 
]

{ #category : 'accessing' }
HsModelEventSink >> snapshotStorage [

	^ snapshotStorage ifNil: [ snapshotStorage := self snapshotStorageClass on: self ]
]

{ #category : 'accessing' }
HsModelEventSink >> snapshotStorage: anObject [

	snapshotStorage := anObject
]

{ #category : 'factory' }
HsModelEventSink >> snapshotStorageClass [
	^ HsSnapshotStorage
]

{ #category : 'accessing' }
HsModelEventSink >> snapshotTaker [

	^ snapshotTaker ifNil: [ snapshotTaker := self snapshotTakerClass on: self ]
]

{ #category : 'accessing' }
HsModelEventSink >> snapshotTaker: anObject [

	snapshotTaker := anObject
]

{ #category : 'factory' }
HsModelEventSink >> snapshotTakerClass [
	^ HsSnapshotTaker 
]

{ #category : 'accessing' }
HsModelEventSink >> spaceId [

	^ spaceId
]

{ #category : 'accessing' }
HsModelEventSink >> spaceId: anObject [

	spaceId := anObject
]

{ #category : 'pulling-events' }
HsModelEventSink >> startPullingEventsFrom: lastEventVersion [
	self eventPuller startFrom: lastEventVersion
]

{ #category : 'pulling-events' }
HsModelEventSink >> startPullingEventsFromLastExecuted [
	self startPullingEventsFrom: self lastExecutedVersion
]

{ #category : 'pulling-events' }
HsModelEventSink >> stopPullingEvents [
	self eventPuller stop
]
