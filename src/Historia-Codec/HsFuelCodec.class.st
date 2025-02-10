Class {
	#name : 'HsFuelCodec',
	#superclass : 'HsCodec',
	#category : 'Historia-Codec',
	#package : 'Historia-Codec'
}

{ #category : 'accessing' }
HsFuelCodec class >> type [
	^ #fuel
]

{ #category : 'actions' }
HsFuelCodec >> materialize: byteArray [
	^ FLMaterializer materializeFromByteArray:
		  byteArray asByteArray 
]

{ #category : 'actions' }
HsFuelCodec >> serialize: objects [
	| bytes |
	bytes := FLSerializer serializeToByteArray: objects.
	^ bytes
]
