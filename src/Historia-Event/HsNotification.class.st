Class {
	#name : 'HsNotification',
	#superclass : 'HsEvent',
	#instVars : [
		'kind'
	],
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'accessing' }
HsNotification class >> typeName [
	^ #_ntf
]

{ #category : 'accessing' }
HsNotification >> arguments: notificationArguments [
	super arguments: notificationArguments asDictionary
]

{ #category : 'converting' }
HsNotification >> asAnnouncement [
	self hasArguments ifFalse: [^ self kind asSymbol asAnnouncement ].
	^ (HsNotificationAnnouncement on: self) kind: self kind
]

{ #category : 'serializing' }
HsNotification >> asCompactDictionary [
	| data |
	data := super asCompactDictionary.
	kind ifNotNil: [ :val | data at: 'knd' put: val ].
	^ data
]

{ #category : 'testing' }
HsNotification >> isNotification [
	^ true
]

{ #category : 'accessing' }
HsNotification >> kind [

	^ kind
]

{ #category : 'accessing' }
HsNotification >> kind: anObject [

	kind := anObject
]

{ #category : 'serializing' }
HsNotification >> readFromCompactDictionary: aDictionary [
	super readFromCompactDictionary: aDictionary.
	aDictionary at: #knd ifPresent: [:val | self kind: val ]
	
]
