Class {
	#name : 'HsEventJournalStorageTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testBuildSendingCommandData [
	| storage ev  codecAndEventData eventData event |
	storage := HsEventJournalStorage new.
	ev := HsCommandEvent new.
	ev targetIds: #('t1' 't2').
	ev argsAt: #a put: 'arg-1'.
	ev undoArgsAt: #u put: 'uarg-1'.
	ev contextAt: #c put: 'ctx-1'.
	ev originatorId: 'oid-1'.
	ev userId: 'uid-1'.
 	codecAndEventData := (storage buildCodecAndEventData: ev) asDictionary.
	self assert: (codecAndEventData at: #codec) equals: storage codecType.
	eventData := (HsCodec type: storage codecType) materialize: (codecAndEventData at: #data).
	event := HsEvent id: 'id-1' data: eventData.
	self assert: (event typeName) equals: HsCommandEvent typeName.
	self assert: (event targetIds) equals: #('t1' 't2').
	self assert: (event eventId) equals: 'id-1'.
	self assert: (event arguments) equals: { #a ->'arg-1' } asDictionary.
	self assert: (event undoArgs) equals: { #u ->'uarg-1' } asDictionary.
	self assert: (event context) equals: { #c ->'ctx-1' } asDictionary.
	self assert: (event originatorId) equals: 'oid-1'.
	self assert: (event userId) equals: 'uid-1'
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testBuildSendingEventData [
	| storage ev  codecAndEventData eventData event |
	storage := HsEventJournalStorage new.
	ev := HsEvent new.
	ev argsAt: #a put: 'arg-1'.
	ev undoArgsAt: #u put: 'uarg-1'.
	ev contextAt: #c put: 'ctx-1'.
	ev originatorId: 'oid-1'.
	ev userId: 'uid-1'.
 	codecAndEventData := (storage buildCodecAndEventData: ev) asDictionary.
	self assert: (codecAndEventData at: #codec) equals: storage codecType.
	eventData := (HsCodec type: storage codecType) materialize: (codecAndEventData at: #data).
	event := HsEvent id: 'id-1' data: eventData.
	self assert: (event eventId) equals: 'id-1'.
	self assert: (event arguments) equals: { #a ->'arg-1' } asDictionary.
	self assert: (event undoArgs) equals: { #u ->'uarg-1' } asDictionary.
	self assert: (event context) equals: { #c ->'ctx-1' } asDictionary.
	self assert: (event originatorId) equals: 'oid-1'.
	self assert: (event userId) equals: 'uid-1'
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testBuildSendingPerformCommandData [
	| storage ev  codecAndEventData eventData event |
	storage := HsEventJournalStorage new.
	ev := HsPerformEvent targetId: 't1' selector: #from:to: arguments: #(2 5).
	ev originatorId: 'oid-1'.
	ev userId: 'uid-1'.
 	codecAndEventData := (storage buildCodecAndEventData: ev) asDictionary.
	self assert: (codecAndEventData at: #codec) equals: storage codecType.
	eventData := (HsCodec type: storage codecType) materialize: (codecAndEventData at: #data).
	event := HsEvent id: 'id-1' data: eventData.
	self assert: (event typeName) equals: HsPerformEvent typeName.
	self assert: (event targetIds) equals: #('t1').
	self assert: (event eventId) equals: 'id-1'.
	self assert: (event arguments) equals: #(2 5).
	self assert: (event originatorId) equals: 'oid-1'.
	self assert: (event userId) equals: 'uid-1'.
	self assert: (event selector) equals: #from:to:
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testDeleteEventAt [
	| spaceId modelSpace vmodel all third deleted trimmed |
	spaceId := 'hs-ejDeleteEventAt'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	modelSpace startPushingEvents.
	1 to: 5 do: [ :idx | 
		vmodel add: idx.
		vmodel save.
	].
	modelSpace eventPusher waitEmptyFor: 50. 
	all := modelSpace eventJournalStorage allEvents.
	self assert: all size equals: 5.
	third := all third.
	deleted := modelSpace eventJournalStorage deleteEventAt: third eventId.
	self assert: deleted.
	trimmed := modelSpace eventJournalStorage allEvents.
	self assert: trimmed size equals: 4.
	self assertCollection: trimmed asArray equals: (all copyWithoutIndex: 3) asArray
	]
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testDeleteEventsAfter [
	| spaceId modelSpace vmodel all firstEight fromMessageId deletedCount trimmed |
	spaceId := 'hs-ejDeleteEventsAfter'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	modelSpace startPushingEvents.
	1 to: 20 do: [ :idx | 
		vmodel add: idx.
		vmodel save.
	].
	modelSpace eventPusher waitEmptyFor: 100. 
	all := modelSpace eventJournalStorage allEvents.
	self assert: all size equals: 20.
	firstEight := OrderedCollection new.
	modelSpace eventJournalStorage eventsDo: [ :ev | firstEight add: ev ] limit: 8.
	fromMessageId := firstEight last eventId.
	deletedCount := modelSpace eventJournalStorage deleteEventsAfter: fromMessageId.
	self assert: deletedCount equals: 12.
	trimmed := modelSpace eventJournalStorage allEvents.
	self assert: trimmed size equals: 8.
	self assert: trimmed first equals: firstEight first.
	self assert: trimmed last equals: firstEight last
	]
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testDeleteEventsBefore [
	| spaceId modelSpace vmodel all firstSix fromMessageId deletedCount trimmed |
	spaceId := 'hs-ejDeleteEventsBefore'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	modelSpace startPushingEvents.
	1 to: 20 do: [ :idx | 
		vmodel add: idx.
		vmodel save.
	].
	modelSpace eventPusher waitEmptyFor: 100. 
	all := modelSpace eventJournalStorage allEvents.
	self assert: all size equals: 20.
	firstSix := OrderedCollection new.
	modelSpace eventJournalStorage eventsDo: [ :ev | firstSix add: ev ] limit: 6.
	fromMessageId := firstSix last eventId.
	deletedCount := modelSpace eventJournalStorage deleteEventsBefore: fromMessageId.
	self assert: deletedCount equals: 5.
	trimmed := modelSpace eventJournalStorage allEvents.
	self assert: trimmed size equals: 15.
	self assert: trimmed first equals: firstSix last
	]
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testEventVersionsFromLimit [
	| spaceId modelSpace vmodel all firstThree nextSix uptoLast |
	spaceId := 'hs-ejEventVersionsFromLimit'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	modelSpace startPushingEvents.
	1 to: 50 do: [ :idx | 
		vmodel add: idx.
		vmodel save.
	].
	modelSpace eventPusher waitEmptyFor: 100. 
	all := modelSpace eventJournalStorage allEvents.
	self assert: all size equals: 50.
	firstThree := OrderedCollection new.
	modelSpace eventJournalStorage eventsDo: [ :ev | firstThree add: ev ] limit: 3.
	nextSix := modelSpace eventJournalStorage eventVersionsFrom: firstThree last eventId limit: 6.
	
	self assertCollection: firstThree asArray equals: (all first: 3) asArray.
	self assert: firstThree last eventId equals: nextSix first.
	self assertCollection: nextSix asArray equals: ((all copyFrom: 3 to: 8) collect: [:e | e eventId]) asArray.
	
	uptoLast := modelSpace eventJournalStorage eventVersionsFrom: nextSix last limit: 100.
	self assert: nextSix last equals: uptoLast first.
	self assertCollection: uptoLast asArray equals: ((all copyFrom: 8 to: 50) collect: [:e | e eventId]) asArray.
	
	]
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testEventVersionsReversedFromLast [
	| spaceId modelSpace vmodel all lastFive |
	spaceId := 'hs-ejEventVersionsReversedFromLast'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	modelSpace startPushingEvents.
	1 to: 50 do: [ :idx | 
		vmodel add: idx.
		vmodel save.
	].
	modelSpace eventPusher waitEmptyFor: 100. 
	all := modelSpace eventJournalStorage allEvents.
	self assert: all size equals: 50.
	
	lastFive := modelSpace eventVersionsReversedFromLast: 5.
	self assertCollection: lastFive asArray equals: ((all last: 5) reversed collect: [:e | e eventId]) asArray.
	]
	
]

{ #category : 'tests' }
HsEventJournalStorageTestCase >> testEventVersionsReversedFromLimit [
	| spaceId modelSpace vmodel all lastThree nextSix uptoFirst |
	spaceId := 'hs-ejEventVersionsReversedFromLimit'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	modelSpace startPushingEvents.
	1 to: 50 do: [ :idx | 
		vmodel add: idx.
		vmodel save.
	].
	modelSpace eventPusher waitEmptyFor: 100. 
	all := modelSpace eventJournalStorage allEvents.
	self assert: all size equals: 50.
	
	lastThree := modelSpace eventVersionsReversedFromLast: 3.
	nextSix := modelSpace eventVersionsReversedFrom: lastThree last limit: 6.
	
	self assertCollection: lastThree asArray equals: ((all last: 3) reversed collect: [:e | e eventId]) asArray.
	self assert: lastThree last equals: nextSix first.
	self assertCollection: nextSix asArray equals: ((all reversed copyFrom: 3 to: 8) collect: [:e | e eventId]) asArray.
	
	uptoFirst := modelSpace eventVersionsReversedFrom: nextSix last limit: 100.
	self assert: nextSix last equals: uptoFirst first.
	self assertCollection: uptoFirst asArray equals: ((all reversed copyFrom: 8 to: all size) collect: [:e | e eventId]) asArray.
	
	]
	
]
