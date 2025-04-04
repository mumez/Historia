Class {
	#name : 'HsSnapshotTaker',
	#superclass : 'Object',
	#instVars : [
		'semaphore',
		'modelSpace',
		'isBusy',
		'lastSnapshotVersion',
		'eventCount'
	],
	#category : 'Historia-Storage',
	#package : 'Historia-Storage'
}

{ #category : 'instance creation' }
HsSnapshotTaker class >> on: aModelSpace [
	^ self new
		  modelSpace: aModelSpace;
		  yourself
]

{ #category : 'actions' }
HsSnapshotTaker >> basicTake: possibleSnapshotVersion [
	| snapshotTimestampAndData |
	snapshotTimestampAndData := self modelSpace saveSnapshot: possibleSnapshotVersion.
	self lastSnapshotVersion: snapshotTimestampAndData first
]

{ #category : 'accessing' }
HsSnapshotTaker >> eventCount [
	^ eventCount ifNil: [eventCount := 0].
]

{ #category : 'private' }
HsSnapshotTaker >> incrementEventCount [
	eventCount := eventCount + 1.
	^ eventCount
]

{ #category : 'initialize-release' }
HsSnapshotTaker >> initEventCount [
	eventCount := 0
]

{ #category : 'initialize-release' }
HsSnapshotTaker >> initialize [
	super initialize.
	isBusy := false.
	semaphore := Semaphore forMutualExclusion.
	self initEventCount.
]

{ #category : 'accessing' }
HsSnapshotTaker >> isBusy [
	^isBusy ifNil: [isBusy := false].
]

{ #category : 'accessing' }
HsSnapshotTaker >> isBusy: aBoolean [
	isBusy := aBoolean == true
]

{ #category : 'accessing' }
HsSnapshotTaker >> lastSnapshotVersion [
	"Answer the value of lastSnapshotVersion"

	^ lastSnapshotVersion
]

{ #category : 'accessing' }
HsSnapshotTaker >> lastSnapshotVersion: anObject [
	"Set the value of lastSnapshotVersion"

	lastSnapshotVersion := anObject
]

{ #category : 'actions' }
HsSnapshotTaker >> listSnapshotVersions [
	^ self modelSpace listSnapshotVersions
]

{ #category : 'accessing' }
HsSnapshotTaker >> modelSpace [
	^ modelSpace
]

{ #category : 'accessing' }
HsSnapshotTaker >> modelSpace: anObject [

	modelSpace := anObject
]

{ #category : 'printing' }
HsSnapshotTaker >> printOn: aStream [
	aStream
		nextPutAll: 'a ';
		nextPutAll: self className;
		nextPutAll: '('.
	aStream
		nextPutAll: ' lastSnapshotTimestampKey: ';
		nextPutAll: self lastSnapshotVersion asString.
	aStream nextPutAll: ')'
]

{ #category : 'actions' }
HsSnapshotTaker >> refreshLastSnapshotTo: snapshotVersion [
	| snapshotArray |
	snapshotArray := self modelSpace loadSnapshot: snapshotVersion.
	self lastSnapshotVersion: snapshotVersion
]

{ #category : 'accessing' }
HsSnapshotTaker >> semaphore [
	"Answer the value of semaphore"

	^ semaphore
]

{ #category : 'accessing' }
HsSnapshotTaker >> settings [
	^ self modelSpace settings
]

{ #category : 'accessing' }
HsSnapshotTaker >> snapshotStorage [

	^ self modelSpace snapshotStorage 
]

{ #category : 'actions' }
HsSnapshotTaker >> take: possibleSnapshotVersion [
	self isBusy ifTrue: [^ self].
	(self snapshotStorage existsRecentSnapshotVersion: possibleSnapshotVersion) ifTrue: [ ^ self ].
	self semaphore
		critical: [
			[
			self isBusy: true.
			self initEventCount.
			self basicTake: possibleSnapshotVersion]
				ensure: [self isBusy: false]]
]

{ #category : 'actions' }
HsSnapshotTaker >> takeIfNeeded: lastPutEventVersion [
	| interval |
	interval := self settings snapshotInterval.
	interval isZero ifTrue: [ ^ self ].
	(self incrementEventCount >= interval) ifTrue: [
		self take: lastPutEventVersion
	]
]
