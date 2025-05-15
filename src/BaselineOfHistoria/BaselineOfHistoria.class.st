Class {
	#name : 'BaselineOfHistoria',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfHistoria',
	#package : 'BaselineOfHistoria'
}

{ #category : 'baseline' }
BaselineOfHistoria >> baseline: spec [

	<baseline>
	spec for: #pharo do: [
		self rediStick: spec.
		spec package: 'Historia-Core' with: [spec requires: #('RediStick')].
		spec package: 'Historia-Codec'.
		spec package: 'Historia-Event' with: [spec requires: #('Historia-Codec' 'Historia-Core')].
		spec package: 'Historia-Event-Processor' with: [spec requires: #('Historia-Event' 'Historia-Storage')].
		spec package: 'Historia-Model' with: [spec requires: #('Historia-Codec' 'Historia-Core' 'Historia-Event' 'RediStick')].
		spec package: 'Historia-Storage' with: [spec requires: #('Historia-Codec' 'Historia-Core' 'Historia-Event' 'RediStick')].
		spec package: 'Historia-Tests' with: [spec requires: #('Core')].
		spec package: 'Historia-Examples-Bank' with: [spec requires: #('Historia-Event' 'Historia-Model')].
		spec package: 'Historia-Examples-Bank-Tests' with: [spec requires: #('Historia-Examples-Bank')].
		spec
			group: 'default' with: #( 'Core' 'Tests' 'Examples' 'Examples-Tests');
			group: 'Core'
			with:
				#( 'Historia-Core' 'Historia-Codec' 'Historia-Event'
				   'Historia-Event-Processor' 'Historia-Model' 'Historia-Storage' );
			group: 'Tests' with: #( 'Historia-Tests' );
			group: 'Examples' with: #('Historia-Examples-Bank');
			group: 'Examples-Tests' with: #('Historia-Examples-Bank-Tests').
		self optionBaselineMessagePack: spec.
		]
]

{ #category : 'external projects' }
BaselineOfHistoria >> messagePack: spec [
	spec
		baseline: 'MessagePack'
		with: [ spec
				repository: 'github://msgpack/msgpack-smalltalk/repository';
				loads: 'default' ]
]

{ #category : 'baseline' }
BaselineOfHistoria >> optionBaselineMessagePack: spec [

	self messagePack: spec.
	spec
		package: 'Historia-Codec-MessagePack'
		with: [ spec requires: #( 'Historia-Codec' 'MessagePack' ) ].
	spec package: 'Historia-Tests-Codec-MessagePack' with: [
		spec requires:
			#( 'Historia-Codec-MessagePack' 'Historia-Tests' 'Historia-Model' ) ].
	spec
		group: 'MessagePackCodec' with: #( 'Historia-Codec-MessagePack' );
		group: 'MessagePackCodec-Tests'
		with: #( 'Historia-Tests-Codec-MessagePack' );
		group: 'MessagePackCodecAll'
		with: #( 'MessagePackCodec' 'MessagePackCodec-Tests' )
]

{ #category : 'external projects' }
BaselineOfHistoria >> rediStick: spec [
	spec
		baseline: 'RediStick'
		with: [ spec
				repository: 'github://mumez/RediStick/repository';
				loads: 'StreamObjects' ]
]
