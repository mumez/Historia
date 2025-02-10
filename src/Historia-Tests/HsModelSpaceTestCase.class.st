Class {
	#name : 'HsModelSpaceTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'tests' }
HsModelSpaceTestCase >> testBasicCatchup [
	| spaceId modelSpace vmodel modelSpace2 |
	spaceId := 'test-stBasicCatchup'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 10 do: [ :each | 
		vmodel value: each.
		vmodel save.
	].
	self assert: (modelSpace eventPusher waitEmptyFor: 500).
	
	self assert: modelSpace snapshotStorage listSnapshotVersions size isZero.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	self assert: (modelSpace2 modelAt: 'val-1') value isNil.
	modelSpace2 snapshotTaker settings snapshotInterval: 6.
	modelSpace2 catchup.
	self sleep: 100.
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 10.
	self assert: modelSpace2 snapshotStorage listSnapshotVersions size equals: 1.
	self assert: modelSpace2 lastExecutedVersion > modelSpace2 lastSnapshotVersion.
	
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testCatchupMoreEvents [
	| spaceId modelSpace vmodel modelSpace2 modelSpace3 |
	spaceId := 'test-stCatchupMoreEvents'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 10 do: [ :each | 
		vmodel value: each.
		vmodel save.
	].
	self assert: (modelSpace eventPusher waitEmptyFor: 500).
	self assert: modelSpace snapshotStorage listSnapshotVersions size isZero.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	self assert: (modelSpace2 modelAt: 'val-1') value isNil.
	modelSpace2 snapshotTaker settings snapshotInterval: 6.
	modelSpace2 catchup.
	self sleep: 100.
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 10.
	self assert: modelSpace2 lastExecutedVersion > modelSpace2 lastSnapshotVersion.
	self assert: modelSpace2 lastSnapshotVersion equals: modelSpace lastSnapshotVersion.
	
	11 to: 20 do: [ :each | 
		vmodel value: each.
		vmodel save.
	].
	self sleep: 100.
	
	modelSpace3 := HsModelSpace spaceId: spaceId.
	modelSpace3 putModel: (HsValueModel id: 'val-1').
	self assert: (modelSpace3 modelAt: 'val-1') value isNil.
	modelSpace3 catchup.
	self sleep: 100.
	
	self assert: (modelSpace3 modelAt: 'val-1') value equals: 20.
	self assert: modelSpace3 lastExecutedVersion equals: modelSpace2 lastExecutedVersion.
	self assert: modelSpace3 snapshotTaker eventCount equals: 2. "playbacks are 19, 20"
	
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 20.
	
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
	modelSpace3 releaseStorages.
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testCreateDeleteModel [
	| spaceId modelSpace vmodel modelSpace2 values2 |
	spaceId := 'test-msCreateDeleteModel'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModelOf: HsOrderedCollectionModel id: 'vals-1'. 
	vmodel := modelSpace modelAt: 'vals-1'.
	1 to: 5 do: [ :idx | vmodel add: idx].
	vmodel save.
	modelSpace eventPusher start.
	self sleep: 50.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	modelSpace2 catchup.
	self sleep: 50.
	values2 := modelSpace2 modelAt: 'vals-1'.
	self assert: values2 size equals: 5.
	self assertCollection: values2 asArray equals: vmodel values asArray.
	
	vmodel delete; save.
	self sleep: 50.
	
	values2 := modelSpace2 modelAt: 'vals-1'.
	self assert: values2 isNil.
	
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testCreateModel [
	| spaceId modelSpace vmodel modelSpace2 values2 |
	spaceId := 'test-msCreateModel'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModelOf: HsOrderedCollectionModel id: 'vals-1'. 
	vmodel := modelSpace modelAt: 'vals-1'.
	1 to: 5 do: [ :idx | vmodel add: idx].
	vmodel save.
	modelSpace eventPusher start.
	self sleep: 50.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	modelSpace2 catchup.
	self sleep: 50.
	values2 := modelSpace2 modelAt: 'vals-1'.
	self assert: values2 size equals: 5.
	self assertCollection: values2 asArray equals: vmodel values asArray.
	
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testEventSave [

	| modelSpace vmodel eventJournal events event |
	modelSpace := HsModelSpace spaceId: 'test-msEventSave'.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.

	vmodel value: 111.
	self assert: vmodel value equals: 111.
	self assert: vmodel pendingEvents size equals: 1.

	vmodel save.
	self assert: vmodel pendingEvents size equals: 0.
	
	self assert: modelSpace eventPusher eventQueue size equals: 1.
	modelSpace eventPusher push.
	self assert: modelSpace eventPusher eventQueue size equals: 0.
	
	eventJournal := HsEventJournalStorage spaceId: modelSpace spaceId.
	events := eventJournal allEvents.
	self assert: events size equals: 1.
	
	event := events first.
	self assert: event class equals: HsValueChanged.
	self assert: event value equals: 111.
	
	modelSpace eventPusher destroy.
	
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testEventSaveWithAutoPush [

	| modelSpace vmodel eventJournal events event |
	modelSpace := HsModelSpace spaceId: 'test-msEventSaveWithAutoPush'.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.

	modelSpace eventPusher start.
	vmodel value: 111.
	self assert: vmodel value equals: 111.
	self assert: vmodel pendingEvents size equals: 1.
	vmodel value: 222.
	self assert: vmodel value equals: 222.
	self assert: vmodel pendingEvents size equals: 2.
	vmodel save.
	self assert: vmodel pendingEvents size equals: 0.
	self assert: modelSpace eventPusher eventQueue size equals: 2.
	self sleep: 500.
	self assert: modelSpace eventPusher eventQueue size equals: 0.
	
	eventJournal := HsEventJournalStorage spaceId: modelSpace spaceId.
	events := eventJournal allEvents.
	self assert: events size equals: 2.
	
	event := events first.
	self assert: event class equals: HsValueChanged.
	self assert: event value equals: 111.
	event := events second.
	self assert: event class equals: HsValueChanged.
	self assert: event value equals: 222.
	
	modelSpace eventPusher destroy.
	
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testExecuteOn [

	| modelSpace addA addB|
	modelSpace := HsModelSpace spaceId: 'test-msExecuteOn'.
	modelSpace modelAt: 'ord1' put: OrderedCollection new.

	addA := HsPerformEvent
		       targetId: 'ord1'
		       selector: #add:
		       arguments: { #a }.
	addA executeOn: modelSpace.
	
	self assert: (modelSpace modelAt: 'ord1') asArray equals: #(#a).
	
	addB := HsPerformEvent
		       targetId: 'ord1'
		       selector: #add:
		       arguments: { #b }.
	addB executeOn: modelSpace.
	
	self assert: (modelSpace modelAt: 'ord1') asArray equals: #(#a #b).
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testPendingEvents [
	| modelSpace vmodel pendingEvents ev |
	modelSpace := HsModelSpace spaceId: 'test-msPendingEvents'.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.

	vmodel value: 12.
	self assert: vmodel value equals: 12.
	pendingEvents := vmodel pendingEvents.
	self assert: pendingEvents size equals: 1.
	ev := pendingEvents first.
	self assert: ev value equals: 12.
	self assert: ev targetId equals: 'val-1'.
	
	vmodel value: 24.
	self assert: vmodel value equals: 24.
	pendingEvents := vmodel pendingEvents.
	self assert: pendingEvents size equals: 2.
	ev := pendingEvents second.
	self assert: ev value equals: 24.
	self assert: ev targetId equals: 'val-1'.
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testSetupFailOnSameModelSpace [
	| spaceId modelSpace vmodel snapshotVersion modelSpace2 |
	spaceId := 'test-msSetupFailOnSameModelSpace'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 4 do: [ :idx |
		vmodel value: idx.
	].
	vmodel save.
	self assert: (modelSpace eventPusher waitEmptyFor: 100).
	modelSpace saveSnapshot: modelSpace lastEventVersion.
	vmodel value: 5.
	vmodel save.
	self assert: (modelSpace eventPusher waitEmptyFor: 50).
	snapshotVersion := modelSpace lastSnapshotVersion.
	self assert: modelSpace snapshotStorage listSnapshotVersions size equals: 1.
	self assert: modelSpace lastEventVersion > snapshotVersion.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	modelSpace2 originatorId: modelSpace originatorId.
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	self assert: (modelSpace2 modelAt: 'val-1') value isNil.
	modelSpace2 setupFrom: snapshotVersion.
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 4.
	self assert: modelSpace2 lastExecutedVersion equals: nil.
	
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testSetupFrom [ 
	| spaceId modelSpace vmodel snapshotVersion modelSpace2 |
	spaceId := 'test-msSetupFrom'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 4 do: [ :idx |
		vmodel value: idx.
	].
	vmodel save.
	self assert: (modelSpace eventPusher waitEmptyFor: 100).
	modelSpace saveSnapshot: modelSpace lastEventVersion.
	vmodel value: 5.
	vmodel save.
	self assert: (modelSpace eventPusher waitEmptyFor: 50).
	snapshotVersion := modelSpace lastSnapshotVersion.
	self assert: modelSpace snapshotStorage listSnapshotVersions size equals: 1.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	self assert: (modelSpace2 modelAt: 'val-1') equals: nil.
	modelSpace2 setupFrom: snapshotVersion.
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 5.
	self assert: modelSpace2 lastExecutedVersion > snapshotVersion.
	
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
]

{ #category : 'tests' }
HsModelSpaceTestCase >> testSetupFromLastSnapshot [
	| spaceId modelSpace vmodel snapshotVersion modelSpace2 |
	spaceId := 'test-stSetupFromLastSnapshot'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 10 do: [ :each | 
		vmodel value: each.
		vmodel save.
		(each rem: 3) = 0 ifTrue: [ 
			self assert: (modelSpace eventPusher waitEmptyFor: 50).
			modelSpace saveSnapshot: modelSpace lastEventVersion.
		]
	].
	snapshotVersion := modelSpace lastSnapshotVersion.
	
	self assert: modelSpace snapshotStorage listSnapshotVersions size equals: 3.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	self assert: (modelSpace2 modelAt: 'val-1') equals: nil.
	modelSpace2 setupFrom: snapshotVersion.
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 10.
	self assert: modelSpace2 lastExecutedVersion > snapshotVersion.
	
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
]
