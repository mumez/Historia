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
