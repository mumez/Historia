Class {
	#name : 'HsEventCodecTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'tests' }
HsEventCodecTestCase >> testAddValuesOnModelWithJsonCodec [
	| spaceId modelSpace vmodel modelSpace2 values2 eventEntry |
	spaceId := 'test-ecAddValuesOnModelWithJsonCodec'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace settings eventCodec: #json.
	modelSpace2 := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace. modelSpace2 } do: [
	self assert: modelSpace eventJournalStorage codecType equals: #json.
	modelSpace putModelOf: HsOrderedCollectionModel id: 'vals-1'.
	vmodel := modelSpace modelAt: 'vals-1'.
	1 to: 5 do: [ :idx | vmodel add: idx].
	vmodel add: #symbol.
	vmodel save.
	modelSpace eventPusher start.
	modelSpace eventPusher waitEmptyFor: 200.
	self assert: (modelSpace2 modelAt: 'vals-1') equals: nil.
	
	modelSpace2 catchup.
	modelSpace eventPusher waitEmptyFor: 200.
	values2 := modelSpace2 modelAt: 'vals-1'.
	self assert: values2 size equals: 6.
	self assertCollection: values2 asArray equals: vmodel values asArray.
	self assert: values2 values last equals: 'symbol'.
	eventEntry := modelSpace eventJournalStorage eventStream last.
	self assert: (eventEntry fieldAt: 'codec') equals: 'json'.
	]
]

{ #category : 'tests' }
HsEventCodecTestCase >> testSimpleJsonCodec [
	| storage ev  codecAndEventData eventData event |
	storage := HsEventJournalStorage new.
	storage settings eventCodec: #json.
	ev := HsEvent new.
	ev argsAt: #a put: 'arg-1'.
	ev undoArgsAt: #u put: 'uarg-1'.
	ev contextAt: #c put: 'ctx-1'.
	ev originatorId: 'oid-1'.
	ev userId: 'uid-1'.
 	codecAndEventData := (storage buildCodecAndEventData: ev) asDictionary.
	self assert: storage codecType equals: #json.
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
