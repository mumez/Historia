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

{ #category : 'announcements' }
HsAnnouncingModelEventSink >> eventAnnouncedDo: aOneArgBlock [
	self announcer when: HsEventAnnouncement do: aOneArgBlock for: self
]

{ #category : 'events' }
HsAnnouncingModelEventSink >> handleSinked: anEvent [
	self announcer announce: anEvent 
]

{ #category : 'announcements' }
HsAnnouncingModelEventSink >> notificationAnnouncedDo: aOneArgBlock [
	self announcer when: HsNotificationAnnouncement do: aOneArgBlock for: self
]
