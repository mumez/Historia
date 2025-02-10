Class {
	#name : 'HsUtils',
	#superclass : 'Object',
	#instVars : [
		'settings'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Historia-Core',
	#package : 'Historia-Core'
}

{ #category : 'accessing' }
HsUtils class >> default [

	^ default ifNil: [ default := self new ]
]

{ #category : 'accessing' }
HsUtils class >> default: anObject [

	default := anObject
]

{ #category : 'class initialization' }
HsUtils class >> initialize [
	default := nil
]

{ #category : 'factory' }
HsUtils >> newEventStreamNamed: aStreamName [
	^ RsStream named: self settings eventStreamPrefix, aStreamName
]

{ #category : 'accessing' }
HsUtils >> settings [

	^ settings ifNil: [ settings := HsSettings defaultCopied ]
]

{ #category : 'accessing' }
HsUtils >> settings: anObject [

	settings := anObject
]
