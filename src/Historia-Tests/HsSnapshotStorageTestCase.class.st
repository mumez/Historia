Class {
	#name : 'HsSnapshotStorageTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'tests' }
HsSnapshotStorageTestCase >> testSaveAndLoad [
	| spaceId versions models modelSpace snapStorage |
	spaceId := 'hs-ssSaveAndLoad'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	models := {#a -> 'aaa'} asDictionary.
	modelSpace models: models.
	modelSpace saveSnapshot: (RsStreamMessageId idWithAutoSequence: 0).
	models at: #a put: 'bbb'.
	modelSpace saveSnapshot: (RsStreamMessageId idWithAutoSequence: 1).
	models at: #a put: 'ccc'.
	modelSpace saveSnapshot: (RsStreamMessageId idWithAutoSequence: 2).
	modelSpace models: nil.
	
	snapStorage := modelSpace snapshotStorage.
	
	versions := snapStorage listSnapshotVersions.
	self assert: versions size equals: 3.
	
	modelSpace loadSnapshot: snapStorage lastSnapshotVersion.
	self assert: (modelSpace models at: #a) equals: 'ccc'.
	
	modelSpace loadSnapshot: versions second.
	self assert: (modelSpace models at: #a) equals: 'bbb'.
	
	modelSpace loadSnapshot: versions first.
	self assert: (modelSpace models at: #a) equals: 'aaa'.
	]
	
]
