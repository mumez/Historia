Class {
	#name : 'HsAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'event'
	],
	#category : 'Historia-Core',
	#package : 'Historia-Core'
}

{ #category : 'instance creation' }
HsAnnouncement class >> on: anEvent [
	^ self new
		  event: anEvent;
		  yourself
]

{ #category : 'accessing' }
HsAnnouncement >> event [

	^ event
]

{ #category : 'accessing' }
HsAnnouncement >> event: anObject [

	event := anObject
]
