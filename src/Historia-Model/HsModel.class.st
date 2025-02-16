Class {
	#name : 'HsModel',
	#superclass : 'Object',
	#instVars : [
		'id',
		'modelSpace',
		'pendingEvents'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'fuel support' }
HsModel class >> fuelIgnoredInstanceVariableNames [
    ^#('modelSpace' 'pendingEvents')
]

{ #category : 'instance creation' }
HsModel class >> id: modelId [

	^ self new
		  id: modelId;
		  yourself
]

{ #category : 'instance creation' }
HsModel class >> on: aModelSpace [

	^ self new
		  modelSpace: aModelSpace;
		  yourself
]

{ #category : 'events' }
HsModel >> addPendingEvent: anEvent [
	self pendingEvents add: anEvent
]

{ #category : 'mutating' }
HsModel >> basicMutate: anEvent [
	anEvent applyTo: self.
	self addPendingEvent: anEvent
]

{ #category : 'releasing' }
HsModel >> delete [
	self mutate: HsModelDeleted using: [ :ev | ev modelId: self id ]
]

{ #category : 'events' }
HsModel >> eventsFlushingDo: aBlock [
	| events pendings |
	events := OrderedCollection new.
	pendings := self pendingEvents.
	[pendings isEmpty] whileFalse: [ 
		events add: pendings removeFirst.
	].
	^ aBlock value: events
]

{ #category : 'events' }
HsModel >> handleSinked: anEvent [
	anEvent applyTo: self
]

{ #category : 'accessing' }
HsModel >> id [

	^ id
]

{ #category : 'accessing' }
HsModel >> id: anObject [

	id := anObject
]

{ #category : 'callback' }
HsModel >> instanceCreated: aModelSpace initializing: initializerBlock [
	self modelSpace: aModelSpace.
	self mutate: self modelCreatedEventClass using: [ :ev |
		ev
			className: self className;
			modelId: self id.
		initializerBlock value: ev ]
]

{ #category : 'factory' }
HsModel >> modelCreatedEventClass [
	^ HsModelCreated
]

{ #category : 'accessing' }
HsModel >> modelSpace [

	^ modelSpace
]

{ #category : 'accessing' }
HsModel >> modelSpace: anObject [

	modelSpace := anObject
]

{ #category : 'mutating' }
HsModel >> mutate: anEventClass [
	self mutate: anEventClass using: [:ev |]
]

{ #category : 'mutating' }
HsModel >> mutate: anEventClass using: mutatorBlock [
	| ev |
	ev := anEventClass originatorId: self modelSpace originatorId targetId: self id.
	mutatorBlock value: ev.
	self basicMutate: ev
]

{ #category : 'notifying' }
HsModel >> notify: notificationKind [
	self notify: notificationKind using: [ :noti |  ]
]

{ #category : 'notifying' }
HsModel >> notify: notificationKind using: aBlock [
	| noti |
	noti := HsNotification originatorId: self modelSpace originatorId targetId: self id.
	noti kind: notificationKind.
	aBlock value: noti.
	self addPendingEvent: noti
]

{ #category : 'accessing' }
HsModel >> pendingEvents [

	^ pendingEvents ifNil: [ pendingEvents := OrderedCollection new ]
]

{ #category : 'accessing' }
HsModel >> pendingEvents: anObject [

	pendingEvents := anObject
]

{ #category : 'saving' }
HsModel >> save [
	self modelSpace save: self
]

{ #category : 'saving' }
HsModel >> saveNotifying: notificationSymbol [
	self notify: notificationSymbol.
	self save.
]

{ #category : 'saving' }
HsModel >> saveNotifying: notificationSymbol withArguments: notificationArgs [
	self notify: notificationSymbol using: [:noti | noti arguments: notificationArgs asDictionary ].
	self save.
]
