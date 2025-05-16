Class {
	#name : 'HsMessagePackCodec',
	#superclass : 'HsCodec',
	#category : 'Historia-Codec-MessagePack',
	#package : 'Historia-Codec-MessagePack'
}

{ #category : 'class initialization' }
HsMessagePackCodec class >> initialize [
	self register
]

{ #category : 'accessing' }
HsMessagePackCodec class >> type [
	^ #mp
]

{ #category : 'actions' }
HsMessagePackCodec >> materialize: byteArray [
	^ Object fromMessagePack: byteArray asByteArray
]

{ #category : 'actions' }
HsMessagePackCodec >> serialize: objects [
	^ objects messagePacked
]
