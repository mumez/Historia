Class {
	#name : 'HsSettings',
	#superclass : 'Object',
	#instVars : [
		'settingsDict'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Historia-Core',
	#package : 'Historia-Core'
}

{ #category : 'instance creation' }
HsSettings class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : 'instance creation' }
HsSettings class >> defaultCopied [
	^ self new initFrom: self default
]

{ #category : 'class initialization' }
HsSettings class >> initialize [
	default := nil
]

{ #category : 'accessing - private' }
HsSettings >> at: key [
	^self settingsDict at: key
]

{ #category : 'accessing - private' }
HsSettings >> at: key ifAbsent: aBlock [
	^self settingsDict at: key ifAbsent: aBlock
]

{ #category : 'accessing - private' }
HsSettings >> at: key ifAbsentPut: aBlock [
	^self settingsDict at: key ifAbsentPut: aBlock
]

{ #category : 'accessing - private' }
HsSettings >> at: key put: value [
	^self settingsDict at: key put: value
]

{ #category : 'shortcuts' }
HsSettings >> disableAutoSnapshot [
	self snapshotInterval: 0
]

{ #category : 'accessing' }
HsSettings >> eventCodec [
	^ self at: #eventCodec ifAbsentPut: [#ston]
]

{ #category : 'accessing' }
HsSettings >> eventCodec: codecName [
	^ self at: #eventCodec put: codecName
]

{ #category : 'accessing' }
HsSettings >> eventStreamPrefix [
	^ self at: #eventStreamPrefix ifAbsentPut: ['historia:']
]

{ #category : 'accessing' }
HsSettings >> eventStreamPrefix: prefixName [
	^ self at: #eventStreamPrefix put: prefixName
]

{ #category : 'initialization' }
HsSettings >> initFrom: otherSettings [
	self initialize.
	otherSettings settingsDict keysAndValuesDo: [ :k :v |
		self settingsDict at: k put: v ]
]

{ #category : 'initialization' }
HsSettings >> initialize [
	settingsDict := nil
]

{ #category : 'accessing' }
HsSettings >> loggerClassName [
	^ self at: #loggerClassName ifAbsentPut: [#SkLocalLogger]
]

{ #category : 'accessing' }
HsSettings >> loggerClassName: aString [
	^ self at: #loggerClassName put: aString
]

{ #category : 'accessing' }
HsSettings >> passClientCommandExecutionError [
	^ self at: #passClientCommandExecutionError ifAbsentPut: [false]
]

{ #category : 'accessing' }
HsSettings >> passClientCommandExecutionError: aBoolean [
	^ self at: #passClientCommandExecutionError put: aBoolean
]

{ #category : 'accessing' }
HsSettings >> passServerEventExecutionError [
	^ self at: #passServerEventExecutionError ifAbsentPut: [false]
]

{ #category : 'accessing' }
HsSettings >> passServerEventExecutionError: aBoolean [
	^ self at: #passServerEventExecutionError put: aBoolean
]

{ #category : 'accessing - private' }
HsSettings >> settingsDict [
	^ settingsDict ifNil: [settingsDict := IdentityDictionary new]
]

{ #category : 'accessing - private' }
HsSettings >> settingsDict: anObject [

	settingsDict := anObject
]

{ #category : 'accessing' }
HsSettings >> shouldAutoStartEventPusher [
	^ self at: #shouldAutoStartEventPusher ifAbsentPut: [true]
]

{ #category : 'accessing' }
HsSettings >> shouldAutoStartEventPusher: aBoolean [
	^ self at: #shouldAutoStartEventPusher put: aBoolean
]

{ #category : 'accessing' }
HsSettings >> snapshotCodec [
	^ self at: #snapshotCodec ifAbsentPut: [#fuel]
]

{ #category : 'accessing' }
HsSettings >> snapshotCodec: codecName [
	^ self at: #snapshotCodec put: codecName
]

{ #category : 'accessing' }
HsSettings >> snapshotInterval [
	^ self
		at: #snapshotInterval
		ifAbsentPut: [50]
]

{ #category : 'accessing' }
HsSettings >> snapshotInterval: anInteger [
	"AzRtSettings snapshotThreshold: 5"
	^ self at: #snapshotInterval put: anInteger asInteger
]

{ #category : 'accessing' }
HsSettings >> snapshotVersionListPrefix [
	^ self at: #snapshotVersionListPrefix ifAbsentPut: [self eventStreamPrefix, 'snapshot_versions:']
]

{ #category : 'accessing' }
HsSettings >> snapshotVersionListPrefix: prefixName [
	^ self at: #snapshotVersionListPrefix put: prefixName
]

{ #category : 'accessing' }
HsSettings >> snapshotVersionsTakeChunkSize [
	^ self at: #snapshotVersionsTakeChunkSize ifAbsentPut: [10]
]

{ #category : 'accessing' }
HsSettings >> snapshotVersionsTakeChunkSize: chunkSize [
	^ self at: #snapshotVersionsTakeChunkSize put: chunkSize
]
