Class {
	#name : 'HsModelEventBridgeTestCase',
	#superclass : 'HsBaseTestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'tests' }
HsModelEventBridgeTestCase >> testEventNotifications [
	| spaceId modelSpace vmodel modelSpace2 announcer events |
	spaceId := 'test-mebEventNotifications'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace2 := HsModelEventBridge spaceId: spaceId.
	self spaces: { modelSpace. modelSpace2 } do: [
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 5 do: [ :each | 
		vmodel value: each.
		vmodel save.
	].
	self assert: (modelSpace eventPusher waitEmptyFor: 500).
	
	
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	announcer := modelSpace2 announcer.
	events := OrderedCollection new.
	announcer when: HsEventAnnouncement do: [:ann | events add: ann event] for: self.
	self assert: (modelSpace2 modelAt: 'val-1') value isNil.
	modelSpace2 catchup.
	self sleep: 100.
	
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 5.
	self assert: (events allSatisfy: [:each | each typeName asSymbol = HsValueChanged typeName]).
	self assertCollection: (events collect: [:each | each value]) asArray equals: #(1 2 3 4 5).
	]
]

{ #category : 'tests' }
HsModelEventBridgeTestCase >> testNotificationsWithArguments [
	| spaceId modelSpace vmodel modelSpace2 announcer events afterAll args |
	spaceId := 'test-mebNotificationsWithArguments'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace2 := HsModelEventBridge spaceId: spaceId.
	self spaces: { modelSpace. modelSpace2 } do: [
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 5 do: [ :each | 
		vmodel value: each.
	].
	vmodel saveNotifying: #allAdded withArguments: {'arg-1' -> 1. 'arg-2' -> 2}.
	self assert: (modelSpace eventPusher waitEmptyFor: 500).
	
	
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	announcer := modelSpace2 announcer.
	events := OrderedCollection new.
	afterAll := OrderedCollection new.
	announcer when: HsEventAnnouncement do: [:ann | events add: ann event] for: self.
	announcer when: HsNotificationAnnouncement do: [:ann | afterAll add: ann event arguments] for: self.
	self assert: (modelSpace2 modelAt: 'val-1') value isNil.
	modelSpace2 catchup.
	self sleep: 100.
	
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 5.
	self assert: (events allSatisfy: [:each | each typeName asSymbol = HsValueChanged typeName]).
	self assertCollection: (events collect: [:each | each value]) asArray equals: #(1 2 3 4 5).
	self assert: afterAll size equals: 1.
	args := afterAll first.
	self assertCollection: args keys sorted equals: #('arg-1' 'arg-2').
	self assert: (args at: 'arg-1') equals: 1.
	self assert: (args at: 'arg-2') equals: 2.
	]
]

{ #category : 'tests' }
HsModelEventBridgeTestCase >> testSimpleModelSpaceNotifications [
	| spaceId modelSpace vmodel modelSpace2 announcer events afterAll notificationKind notificationArgs|
	spaceId := 'test-mebSimpleModelSpaceNotifications'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace2 := HsModelEventBridge spaceId: spaceId.
	self spaces: { modelSpace. modelSpace2 } do: [
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 5 do: [ :each | 
		vmodel value: each.
	].
	vmodel save.
	modelSpace notify: #allAdded.
	vmodel value: 6; save.
	modelSpace notify: #sixAddedWithArgs withArguments: {'arg-1' -> 1. 'arg-2' -> 2}.
	self assert: (modelSpace eventPusher waitEmptyFor: 500).
	
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	announcer := modelSpace2 announcer.
	events := OrderedCollection new.
	afterAll := OrderedCollection new.
	announcer when: #allAdded do: [:ann | afterAll add: (ann -> (modelSpace2 modelAt: 'val-1') value)] for: self.
	modelSpace2 eventAnnouncedDo: [:ann | events add: ann event].
	modelSpace2 notificationAnnouncedDo: [:ann | 
		notificationKind := ann event kind.
		notificationArgs := ann event arguments
	].
	self assert: (modelSpace2 modelAt: 'val-1') value isNil.
	modelSpace2 catchup.
	self sleep: 100.
	
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 6.
	self assert: (events allSatisfy: [:each | each typeName asSymbol = HsValueChanged typeName]).
	self assertCollection: (events collect: [:each | each value]) asArray equals: #(1 2 3 4 5 6).
	self assert: (afterAll size) equals: 1.
	self assert: (afterAll first) key equals: #allAdded.
	self assert: (afterAll first) value equals: 5.
	self assert: notificationKind equals: #sixAddedWithArgs.
	self assertCollection: notificationArgs keys sorted equals: #('arg-1' 'arg-2').
	]
]

{ #category : 'tests' }
HsModelEventBridgeTestCase >> testSimpleNotifications [
	| spaceId modelSpace vmodel modelSpace2 announcer events afterAll|
	spaceId := 'test-mebSimpleNotifications'.
	modelSpace := HsModelSpace spaceId: spaceId.
	modelSpace2 := HsModelEventBridge spaceId: spaceId.
	self spaces: { modelSpace. modelSpace2 } do: [
	modelSpace putModel: (HsValueModel id: 'val-1').
	vmodel := modelSpace modelAt: 'val-1'.
	modelSpace eventPusher start.
	1 to: 5 do: [ :each | 
		vmodel value: each.
	].
	vmodel saveNotifying: #allAdded.
	self assert: (modelSpace eventPusher waitEmptyFor: 500).
	
	modelSpace2 putModel: (HsValueModel id: 'val-1').
	announcer := modelSpace2 announcer.
	events := OrderedCollection new.
	afterAll := OrderedCollection new.
	announcer when: HsEventAnnouncement do: [:ann | events add: ann event] for: self.
	announcer when: #allAdded do: [:ann | afterAll add: (ann -> (modelSpace2 modelAt: 'val-1') value)] for: self.
	self assert: (modelSpace2 modelAt: 'val-1') value isNil.
	modelSpace2 catchup.
	self sleep: 100.
	
	self assert: (modelSpace2 modelAt: 'val-1') value equals: 5.
	self assert: (events allSatisfy: [:each | each typeName asSymbol = HsValueChanged typeName]).
	self assertCollection: (events collect: [:each | each value]) asArray equals: #(1 2 3 4 5).
	self assert: (afterAll size) equals: 1.
	self assert: (afterAll first) key equals: #allAdded.
	self assert: (afterAll first) value equals: 5.
	]
]
