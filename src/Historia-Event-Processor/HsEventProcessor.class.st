Class {
	#name : 'HsEventProcessor',
	#superclass : 'Object',
	#instVars : [
		'eventQueue',
		'settings',
		'spaceId',
		'loopingProcess',
		'loopingPriority',
		'shouldKeepProcessing'
	],
	#category : 'Historia-Event-Processor',
	#package : 'Historia-Event-Processor'
}

{ #category : 'defaults' }
HsEventProcessor >> defaultLoopingPriority [
	^ Processor userBackgroundPriority 
]

{ #category : 'releasing' }
HsEventProcessor >> destroy [
	self kill.
	self eventStream beEmptyAndReset.
	self eventStream stick endpoint del: {self spaceId}.
]

{ #category : 'accessing' }
HsEventProcessor >> eventQueue [

	^ eventQueue
]

{ #category : 'accessing' }
HsEventProcessor >> eventStream [
	self subclassResponsibility 
]

{ #category : 'initializing' }
HsEventProcessor >> initialize [
	super initialize.
	shouldKeepProcessing := false.
	eventQueue := SharedQueue new
]

{ #category : 'testing' }
HsEventProcessor >> isEmpty [
	^ self queueSize isZero
]

{ #category : 'running' }
HsEventProcessor >> keepProcessing [
	[ self shouldKeepProcessing ] whileTrue: [ self process ]
]

{ #category : 'running' }
HsEventProcessor >> kill [
	loopingProcess ifNil: [ ^self ].
	loopingProcess terminate.
	shouldKeepProcessing := false
]

{ #category : 'accessing' }
HsEventProcessor >> loopingPriority [

	^ loopingPriority ifNil: [ loopingPriority := self defaultLoopingPriority ]
]

{ #category : 'accessing' }
HsEventProcessor >> loopingPriority: anObject [

	loopingPriority := anObject
]

{ #category : 'accessing' }
HsEventProcessor >> loopingProcess [

	^ loopingProcess
]

{ #category : 'accessing' }
HsEventProcessor >> loopingProcess: anObject [

	loopingProcess := anObject
]

{ #category : 'actions' }
HsEventProcessor >> process [
	self subclassResponsibility 
]

{ #category : 'actions' }
HsEventProcessor >> queueEvent: anEvent [
	self eventQueue nextPut: anEvent
]

{ #category : 'actions' }
HsEventProcessor >> queueEvents: aCollectionOfEvent [
	self eventQueue nextPutAll: aCollectionOfEvent
]

{ #category : 'accessing' }
HsEventProcessor >> queueSize [
	^ self eventQueue size
]

{ #category : 'accessing' }
HsEventProcessor >> settings [
	^ settings ifNil: [ settings := HsSettings defaultCopied ]
]

{ #category : 'accessing' }
HsEventProcessor >> settings: anObject [

	settings := anObject
]

{ #category : 'accessing' }
HsEventProcessor >> shouldKeepProcessing [

	^ shouldKeepProcessing
]

{ #category : 'accessing' }
HsEventProcessor >> shouldKeepProcessing: anObject [

	shouldKeepProcessing := anObject
]

{ #category : 'utilities' }
HsEventProcessor >> sleep: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]

{ #category : 'accessing' }
HsEventProcessor >> spaceId [

	^ spaceId
]

{ #category : 'accessing' }
HsEventProcessor >> spaceId: anObject [

	spaceId := anObject
]

{ #category : 'running' }
HsEventProcessor >> start [
	self shouldKeepProcessing ifTrue: [ ^ false ].
	self shouldKeepProcessing: true.
	loopingProcess := [self keepProcessing] forkAt: self loopingPriority.
	^ true 
]

{ #category : 'running' }
HsEventProcessor >> stop [
	self eventQueue nextPut: self stopMark.
	self shouldKeepProcessing: false
]

{ #category : 'constants' }
HsEventProcessor >> stopMark [
	self subclassResponsibility 
]

{ #category : 'utilities' }
HsEventProcessor >> waitEmptyFor: totalMilliseconds [
	^ self waitEmptyFor: totalMilliseconds interval: 20
]

{ #category : 'utilities' }
HsEventProcessor >> waitEmptyFor: totalMilliseconds interval: interalMilliseconds [
	| leftMilliseconds result |
	totalMilliseconds <= 0  ifTrue: [ ^ false ].
	leftMilliseconds := totalMilliseconds.
	result := self isEmpty.
	result ifFalse: [
		self sleep: interalMilliseconds.
		^ self
			  waitEmptyFor: (totalMilliseconds - interalMilliseconds) abs
			  interval: interalMilliseconds ].
	^ result
]
