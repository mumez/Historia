Class {
	#name : 'HsLogger',
	#superclass : 'Object',
	#instVars : [
		'actualLogger',
		'settings'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Historia-Core',
	#package : 'Historia-Core'
}

{ #category : 'accessing' }
HsLogger class >> default [

	^ default ifNil: [ default := self new ]
]

{ #category : 'accessing' }
HsLogger class >> default: anObject [

	default := anObject
]

{ #category : 'class initialization' }
HsLogger class >> initialize [
	default := nil
]

{ #category : 'accessing' }
HsLogger >> actualLogger [

	^ actualLogger ifNil: [ actualLogger := self defaultLoggerClass new ]
]

{ #category : 'accessing' }
HsLogger >> actualLogger: anObject [

	actualLogger := anObject
]

{ #category : 'actions' }
HsLogger >> debug: record [
	self actualLogger debug: record 
]

{ #category : 'defaults' }
HsLogger >> defaultLoggerClass [
	^ Smalltalk globals at: self settings loggerClassName ifAbsent: [ SkLocalLogger ]
]

{ #category : 'actions' }
HsLogger >> error: record [
	self actualLogger error: record 
]

{ #category : 'actions' }
HsLogger >> info: record [
	self actualLogger info: record 
]

{ #category : 'accessing' }
HsLogger >> settings [

	^ settings ifNil: [ settings := HsSettings defaultCopied ]
]

{ #category : 'accessing' }
HsLogger >> settings: anObject [

	settings := anObject
]

{ #category : 'actions' }
HsLogger >> warn: record [
	self actualLogger warn: record 
]
