Class {
	#name : 'HsEventPusher',
	#superclass : 'HsEventProcessor',
	#instVars : [
		'eventJournalStorage'
	],
	#category : 'Historia-Event-Processor',
	#package : 'Historia-Event-Processor'
}

{ #category : 'instance creation' }
HsEventPusher class >> on: aModelSpace [
	^ self new
		  initWithModelSpace: aModelSpace;
		  yourself
]

{ #category : 'instance creation' }
HsEventPusher class >> spaceId: aSpaceId [
	^ self new
		  spaceId: aSpaceId;
		  yourself
]

{ #category : 'releasing' }
HsEventPusher >> destroy [
	super destroy.
	eventJournalStorage := nil
]

{ #category : 'accessing' }
HsEventPusher >> eventJournalStorage [
	^ eventJournalStorage ifNil: [
		  eventJournalStorage := (HsEventJournalStorage spaceId:
				                          self spaceId)
			                         settings: self settings;
			                         yourself ]
]

{ #category : 'accessing' }
HsEventPusher >> eventJournalStorage: anObject [

	eventJournalStorage := anObject
]

{ #category : 'accessing' }
HsEventPusher >> eventStream [
	^ self eventJournalStorage eventStream
]

{ #category : 'initializing' }
HsEventPusher >> initWithModelSpace: aModelSpace [
	spaceId := aModelSpace spaceId.
	settings := aModelSpace settings.
	eventJournalStorage := aModelSpace eventJournalStorage.
	
	settings shouldAutoStartEventPusher ifTrue: [ self start ]
]

{ #category : 'actions' }
HsEventPusher >> process [
	self push
]

{ #category : 'actions' }
HsEventPusher >> push [
	| nextEvent |
	nextEvent := self eventQueue next.
	nextEvent == self stopMark ifTrue: [ ^ self ].
	^ self putEvent: nextEvent
]

{ #category : 'private' }
HsEventPusher >> putEvent: anEvent [
	| messageId |
	anEvent ifNil: [ ^ self ].
	messageId := self eventJournalStorage putEvent: anEvent.
	^ messageId
]

{ #category : 'constants' }
HsEventPusher >> stopMark [
	^ #HS_PUSH_STOP
]
