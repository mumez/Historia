Class {
	#name : 'HsCodec',
	#superclass : 'Object',
	#instVars : [
		'type'
	],
	#classVars : [
		'CodecDictionary'
	],
	#category : 'Historia-Codec',
	#package : 'Historia-Codec'
}

{ #category : 'accessing' }
HsCodec class >> codecDictionary [
	^ CodecDictionary ifNil: [ CodecDictionary := Dictionary new ]
]

{ #category : 'class initialization' }
HsCodec class >> initialize [
	CodecDictionary := nil.
	self allSubclassesDo: [ :cls | cls isAbstract ifFalse: [ cls register ] ]
]

{ #category : 'testing' }
HsCodec class >> isAbstract [
	"override if you need"
	^ self = HsCodec 
]

{ #category : 'materializing' }
HsCodec class >> materializeCodecAndData: codecAndData [
	| codecAndDataDict codecType data codec |
	codecAndDataDict := codecAndData asDictionary.
	codecType := codecAndDataDict at: #codec ifAbsent:[].
	data := codecAndDataDict at: #data ifAbsent:[].
	codec :=  self type: codecType.
	^ codec materialize: data.
	
]

{ #category : 'registering' }
HsCodec class >> register [
	self codecDictionary at: self type put: self new
]

{ #category : 'accessing' }
HsCodec class >> type [
	^ #unknown
]

{ #category : 'instance creation' }
HsCodec class >> type: codecType [
	^ self codecDictionary at: codecType
]

{ #category : 'actions' }
HsCodec >> materialize: byteArray [
]

{ #category : 'actions' }
HsCodec >> serialize: objects [
]

{ #category : 'accessing' }
HsCodec >> type [

	^ type
]

{ #category : 'accessing' }
HsCodec >> type: anObject [

	type := anObject
]
