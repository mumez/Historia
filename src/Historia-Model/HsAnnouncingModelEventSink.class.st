Class {
	#name : 'HsAnnouncingModelEventSink',
	#superclass : 'HsModelEventSink',
	#instVars : [
		'announcer'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'accessing' }
HsAnnouncingModelEventSink >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'accessing' }
HsAnnouncingModelEventSink >> announcer: anObject [

	announcer := anObject
]

{ #category : 'events' }
HsAnnouncingModelEventSink >> handleSinked: anEvent [
	self announcer announce: anEvent 
]
