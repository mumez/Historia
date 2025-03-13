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

{ #category : 'tests' }
HsSnapshotStorageTestCase >> testSnapshotVersions [
	| spaceId versions models modelSpace snapStorage versionString olderVersionString |
	spaceId := 'hs-ssSnapshotVersions'.
	modelSpace := HsModelSpace spaceId: spaceId.
	self spaces: { modelSpace } do: [
	models := {#num -> 0} asDictionary.
	modelSpace models: models.
	1 to: 20 do: [ :idx |
		models at: #num put: idx.
		modelSpace saveSnapshot: (RsStreamMessageId mainId: idx * 100 subId: idx).
	].
	snapStorage := modelSpace snapshotStorage.
	snapStorage settings snapshotVersionsTakeChunkSize: 7.
	versions := snapStorage listSnapshotVersions.
	self assert: versions size equals: 20.
	
	versionString := '1500-15'.
	self assert: (snapStorage existsRecentSnapshotVersion: versionString).
	
	olderVersionString := '1000-10'.
	self deny: (snapStorage existsRecentSnapshotVersion: olderVersionString).
	
	self assert: (snapStorage recentSnapshotVersionFrom: '1300-15') equals: '1300-13'.
	self assert: (snapStorage recentSnapshotVersionFrom: '200-2') equals: '100-1'.
	
	]
	
]
