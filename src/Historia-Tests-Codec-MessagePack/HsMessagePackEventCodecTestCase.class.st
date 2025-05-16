Class {
	#name : 'HsMessagePackEventCodecTestCase',
	#superclass : 'HsEventCodecTestCase',
	#category : 'Historia-Tests-Codec-MessagePack',
	#package : 'Historia-Tests-Codec-MessagePack'
}

{ #category : 'fixtures' }
HsMessagePackEventCodecTestCase >> eventCodecType [
	^ #mp
]

{ #category : 'tests' }
HsMessagePackEventCodecTestCase >> testAddValuesOnModelWithMessagePackCodec [
	| spaceId modelSpace vmodel floatA symbolA dateAndTimeA modelSpace2 values2 vals eventEntry |
	spaceId := 'test-ecAddValuesOnModelWithMessagePackCodec'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace settings eventCodec: self eventCodecType.
	modelSpace2 := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace. modelSpace2 } do: [
	self assert: modelSpace eventJournalStorage codecType equals: self eventCodecType.
	modelSpace putModelOf: HsOrderedCollectionModel id: 'vals-1'.
	vmodel := modelSpace modelAt: 'vals-1'.
	vmodel add: (floatA := 3.141592653589793).
	vmodel add: (symbolA := #symbol).
	vmodel add: (dateAndTimeA := DateAndTime now).
	vmodel save.
	modelSpace eventPusher start.
	modelSpace eventPusher waitEmptyFor: 200.
	self assert: (modelSpace2 modelAt: 'vals-1') equals: nil.
	
	modelSpace2 catchup.
	modelSpace eventPusher waitEmptyFor: 200.
	values2 := modelSpace2 modelAt: 'vals-1'.
	self assert: values2 size equals: 3.
	self assertCollection: values2 asArray equals: vmodel values asArray.
	vals := values2 values.
	self assert: (vals at: 1) equals: floatA.
	self assert: (vals at: 2) equals: symbolA.
	self assert: (vals at: 3) equals: dateAndTimeA.
	eventEntry := modelSpace eventJournalStorage eventStream last.
	self assert: (eventEntry fieldAt: 'codec') equals: 'mp'.
	]
]

{ #category : 'tests' }
HsMessagePackEventCodecTestCase >> testSimpleEventCodec [
	super testSimpleEventCodec
]
