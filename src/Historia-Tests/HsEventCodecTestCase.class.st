Class {
	#name : 'HsEventCodecTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'fixtures' }
HsEventCodecTestCase >> eventCodecType [
	^ #ston
]

{ #category : 'tests' }
HsEventCodecTestCase >> testSimpleEventCodec [
	| storage ev  codecAndEventData eventData event |
	storage := HsEventJournalStorage new.
	storage settings eventCodec: self eventCodecType.
	ev := HsEvent new.
	ev argsAt: #a put: 'arg-1'.
	ev undoArgsAt: #u put: 'uarg-1'.
	ev contextAt: #c put: 'ctx-1'.
	ev originatorId: 'oid-1'.
	ev userId: 'uid-1'.
 	codecAndEventData := (storage buildCodecAndEventData: ev) asDictionary.
	self assert: storage codecType equals: self eventCodecType.
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
