Class {
	#name : 'HsModelSpace',
	#superclass : 'HsModelEventSink',
	#instVars : [
		'eventPusher'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'defaults' }
HsModelSpace >> defaultSettings [
	^ super defaultSettings
		  shouldAutoStartEventPusher: false;
		  yourself
]

{ #category : 'accessing' }
HsModelSpace >> eventPusher [

	^ eventPusher ifNil: [ eventPusher := self eventPusherClass on: self ]
]

{ #category : 'accessing' }
HsModelSpace >> eventPusher: anObject [

	eventPusher := anObject
]

{ #category : 'factory' }
HsModelSpace >> eventPusherClass [
	^ HsEventPusher 
]

{ #category : 'events' }
HsModelSpace >> fireEvent: anEvent [	
	self eventPusher queueEvent: anEvent
]

{ #category : 'releasing' }
HsModelSpace >> releaseStorages [
	self eventPusher destroy.
	super releaseStorages 
]

{ #category : 'saving' }
HsModelSpace >> save: aModel [
	aModel eventsFlushingDo: [:events | self eventPusher queueEvents: events]
]

{ #category : 'saving' }
HsModelSpace >> saveAll: aCollectionOfModel [
	| events |
	events := aCollectionOfModel gather: [ :each | each eventsFlushingDo: [:evs | evs] ].
	self eventPusher queueEvents: events
]

{ #category : 'snapshotting' }
HsModelSpace >> saveSnapshot [
	^ self saveSnapshot: self lastSnapshotVersion
]

{ #category : 'snapshotting' }
HsModelSpace >> saveSnapshot: snapshotVersion [
	^ self snapshotStorage snapshotAt: snapshotVersion put: self models
]

{ #category : 'snapshotting' }
HsModelSpace >> snapshotInterval: anInteger [
	self settings snapshotInterval: anInteger 
]

{ #category : 'snapshotting' }
HsModelSpace >> snapshotVersionsReversedFrom: version limit: limit [
	^ self snapshotStorage snapshotVersionsReversedFrom: version limit: limit
]

{ #category : 'snapshotting' }
HsModelSpace >> snapshotVersionsReversedFromLast: limit [
	^ self snapshotStorage snapshotVersionsReversedFromLast: limit
]

{ #category : 'pushing-events' }
HsModelSpace >> startPushingEvents [
	self eventPusher start
]

{ #category : 'pushing-events' }
HsModelSpace >> stopPushingEvents [
	self eventPusher stop
]
