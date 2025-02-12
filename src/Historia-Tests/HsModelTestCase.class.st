Class {
	#name : 'HsModelTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'tests' }
HsModelTestCase >> testAddAndRemoveValuesOnModel [
	| spaceId modelSpace vmodel modelSpace2 values2 |
	spaceId := 'test-mdAddAndRemoveValuesOnModel'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace2 := HsModelSpace spaceId: spaceId.
	[  
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	1 to: 5 do: [ :idx | vmodel add: idx].
	vmodel save.
	modelSpace eventPusher start.
	modelSpace eventPusher waitEmptyFor: 200.
	
	modelSpace2 putModel: (HsOrderedCollectionModel id: 'vals-1').
	self assert: (modelSpace2 modelAt: 'vals-1') values asArray equals: #().
	modelSpace2 catchup.
	
	values2 := modelSpace2 modelAt: 'vals-1'.
	self assert: values2 size equals: 5.
	self assertCollection: values2 asArray equals: vmodel values asArray.
	
	1 to: 4 do: [ :idx | vmodel remove: idx].
	vmodel save.
	modelSpace eventPusher waitEmptyFor: 100.
	[ modelSpace2 lastExecutedVersion = modelSpace2 lastEventVersion] whileFalse: [  
		modelSpace eventPusher waitEmptyFor: 100.
	].
	self assert: values2 size equals: 1.
	
	] ensure: [
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
	]
]

{ #category : 'tests' }
HsModelTestCase >> testAddValuesOnModel [
	| spaceId modelSpace vmodel modelSpace2 values2 |
	spaceId := 'test-mdAddValuesOnModel'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace2 := HsModelSpace spaceId: spaceId.
	[
	modelSpace putModel: (HsOrderedCollectionModel id: 'vals-1').
	vmodel := modelSpace modelAt: 'vals-1'.
	1 to: 5 do: [ :idx | vmodel add: idx].
	vmodel save.
	modelSpace eventPusher start.
	modelSpace eventPusher waitEmptyFor: 200.
	
	modelSpace2 putModel: (HsOrderedCollectionModel id: 'vals-1').
	self assert: (modelSpace2 modelAt: 'vals-1') values asArray equals: #().
	modelSpace2 catchup.
	modelSpace eventPusher waitEmptyFor: 200.
	values2 := modelSpace2 modelAt: 'vals-1'.
	self assert: values2 size equals: 5.
	self assertCollection: values2 asArray equals: vmodel values asArray.

	] ensure: [
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
	]
]

{ #category : 'tests' }
HsModelTestCase >> testSaveLoadSnapshots [
	| spaceId modelSpace vmodel snapshotVersion modelSpace2 |
	spaceId := 'test-mdSaveLoadSnapshots'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace2 := HsModelSpace spaceId: spaceId.
	[
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	self assert: modelSpace lastSnapshotVersion equals: nil.
	vmodel value: 1.
	vmodel value: 2.
	vmodel value: 3.
	vmodel save.
	self sleep: 50.
	snapshotVersion := modelSpace lastEventVersion.
	modelSpace saveSnapshot: snapshotVersion.
	vmodel value: 4.
	vmodel value: 5.
	vmodel save.
	self sleep: 50.
	self assert: modelSpace snapshotStorage listSnapshotVersions size equals: 1.
	
	self assert: (modelSpace2 modelAt: 'val-1') equals: nil.
	modelSpace2 loadSnapshot: snapshotVersion.
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 3.
	
	] ensure: [
	modelSpace releaseStorages.
	modelSpace2 releaseStorages.
	]
]
