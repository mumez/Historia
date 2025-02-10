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
