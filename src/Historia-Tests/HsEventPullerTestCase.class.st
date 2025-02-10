Class {
	#name : 'HsEventPullerTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'tests' }
HsEventPullerTestCase >> testPullEvents [
	| spaceId modelSpace vmodel modelSpace2 puller vmodel2 |
	spaceId := 'test-eventPullEvents'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	
	vmodel value: 1.
	vmodel value: 2.
	vmodel value: 3.
	vmodel save.
	
	modelSpace2 := HsModelSpace spaceId: spaceId.
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	puller := modelSpace2 eventPuller.
	puller loopingPriority: Processor userSchedulingPriority.
	puller startFrom: '1-0'.
	self sleep: 50.
	modelSpace eventPusher start.
	self sleep: 50.
	vmodel2 := modelSpace2 modelAt: 'val-1'.
	self assert: (vmodel2 value) equals: 3.
	self assert: (modelSpace eventJournalStorage lastEventVersion) equals: (modelSpace2 lastExecutedVersion).
	
	modelSpace eventPusher destroy.
	modelSpace2 eventPuller destroy.
]
