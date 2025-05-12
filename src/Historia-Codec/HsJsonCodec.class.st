Class {
	#name : 'HsJsonCodec',
	#superclass : 'HsCodec',
	#category : 'Historia-Codec',
	#package : 'Historia-Codec'
}

{ #category : 'accessing' }
HsJsonCodec class >> type [
	^ #json
]

{ #category : 'actions' }
HsJsonCodec >> materialize: jsonString [
	^ STONJSON fromString: jsonString
]

{ #category : 'actions' }
HsJsonCodec >> serialize: objects [
	^ STONJSON toString: objects
]
