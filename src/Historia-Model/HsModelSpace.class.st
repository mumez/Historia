Class {
	#name : 'HsModelSpace',
	#superclass : 'HsModelEventSink',
	#instVars : [
		'eventPusher'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

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
HsModelSpace >> saveSnapshot: snapshotVersion [
	^ self snapshotStorage snapshotAt: snapshotVersion put: self models
]
