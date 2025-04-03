Class {
	#name : 'HsModelEventBridge',
	#superclass : 'HsModelEventSink',
	#instVars : [
		'announcer'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'accessing' }
HsModelEventBridge >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'accessing' }
HsModelEventBridge >> announcer: anObject [

	announcer := anObject
]

{ #category : 'announcements' }
HsModelEventBridge >> eventAnnouncedDo: aOneArgBlock [
	self announcer when: HsEventAnnouncement do: aOneArgBlock for: self
]

{ #category : 'events' }
HsModelEventBridge >> handleSinked: anEvent [
	self announcer announce: anEvent 
]

{ #category : 'announcements' }
HsModelEventBridge >> notificationAnnouncedDo: aOneArgBlock [
	self announcer when: HsNotificationAnnouncement do: aOneArgBlock for: self
]
