Class {
	#name : 'HsJsonEventCodecTestCase',
	#superclass : 'HsEventCodecTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'fixtures' }
HsJsonEventCodecTestCase >> eventCodecType [
	^ #json
]

{ #category : 'tests' }
HsJsonEventCodecTestCase >> testAddValuesOnModelWithJsonCodec [
	| spaceId modelSpace vmodel modelSpace2 values2 eventEntry |
	spaceId := 'test-ecAddValuesOnModelWithJsonCodec'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace settings eventCodec: self eventCodecType.
	modelSpace2 := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace. modelSpace2 } do: [
	self assert: modelSpace eventJournalStorage codecType equals: self eventCodecType.
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
HsJsonEventCodecTestCase >> testSimpleEventCodec [
	super testSimpleEventCodec
]
