Class {
	#name : 'HsEventPuller',
	#superclass : 'HsEventProcessor',
	#instVars : [
		'poller',
		'eventStream',
		'eventProcessDelegate'
	],
	#category : 'Historia-Event-Processor',
	#package : 'Historia-Event-Processor'
}

{ #category : 'instance creation' }
HsEventPuller class >> on: aModelSpace [
	^ (self spaceId: aModelSpace spaceId)
		  eventProcessDelegate: aModelSpace;
		  settings: aModelSpace settings;
		  yourself
]

{ #category : 'instance creation' }
HsEventPuller class >> spaceId: aSpaceId [
	^ self new
		  spaceId: aSpaceId;
		  yourself
]

{ #category : 'releasing' }
HsEventPuller >> destroy [
	super destroy.
	self initPoller
]

{ #category : 'accessing' }
HsEventPuller >> eventProcessDelegate [

	^ eventProcessDelegate
]

{ #category : 'accessing' }
HsEventPuller >> eventProcessDelegate: anObject [

	eventProcessDelegate := anObject
]

{ #category : 'accessing' }
HsEventPuller >> eventStream [
	^ eventStream ifNil: [ eventStream := HsUtils default newEventStreamNamed: self spaceId ]
]

{ #category : 'initializing' }
HsEventPuller >> initPoller [
	poller := nil
]

{ #category : 'testing' }
HsEventPuller >> isConnected [
	^ self eventStream stick isConnected 
]

{ #category : 'running' }
HsEventPuller >> kill [
	super kill.
	self killPoller
]

{ #category : 'running' }
HsEventPuller >> killPoller [
	^ self poller ifNotNil: [ :p | p kill]
]

{ #category : 'event poller callback' }
HsEventPuller >> onReceive: anEntry [
	| restoredEvent |
	restoredEvent := HsEvent fromStreamEntry: anEntry.
	self queueEvent: restoredEvent
]

{ #category : 'accessing' }
HsEventPuller >> poller [
	^ poller
]

{ #category : 'private' }
HsEventPuller >> preparePoller: lastEventVersion [
	| newPoller |
	newPoller := lastEventVersion
		             ifNil: [ self eventStream pollerIncoming ]
		             ifNotNil: [
		             self eventStream pollerNextFrom:
			             lastEventVersion asStreamMessageId ].

	newPoller onReceive: [ :entry | self onReceive: entry ].
	^ newPoller
]

{ #category : 'printing' }
HsEventPuller >> printOn: aStream [
	aStream nextPutAll: '[event puller] '.
	aStream
		nextPutAll: ' running->';
		nextPutAll: self shouldKeepProcessing asString
]

{ #category : 'actions' }
HsEventPuller >> process [
	self isConnected ifFalse: [ ^ self sleep: 100 ].
	self processPulledEvent
]

{ #category : 'event handling' }
HsEventPuller >> processPulledEvent [
	| nextEvent |
	nextEvent := self eventQueue next.
	nextEvent == self stopMark ifTrue: [
		^ self shouldKeepProcessing: false ].
	self eventProcessDelegate processPulledEvent: nextEvent
]

{ #category : 'initializing' }
HsEventPuller >> resetPoller: lastEventVersion [
	poller := self preparePoller: lastEventVersion 
]

{ #category : 'running' }
HsEventPuller >> startFrom: lastEventVersion [
	self start ifFalse: [ ^self ].
	self resetPoller: lastEventVersion.
	self poller start.
]

{ #category : 'running' }
HsEventPuller >> stop [
	self poller ifNotNil: [:e| e stop].
	self initPoller.
	
	super stop
]

{ #category : 'constants' }
HsEventPuller >> stopMark [
	^ #HS_PUSH_STOP
]
