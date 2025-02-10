Class {
	#name : 'HsStonCodec',
	#superclass : 'HsCodec',
	#category : 'Historia-Codec',
	#package : 'Historia-Codec'
}

{ #category : 'accessing' }
HsStonCodec class >> type [
	^ #ston
]

{ #category : 'actions' }
HsStonCodec >> materialize: stonString [
	^ STON fromString: stonString
]

{ #category : 'actions' }
HsStonCodec >> serialize: objects [
	^ STON toString: objects
]
