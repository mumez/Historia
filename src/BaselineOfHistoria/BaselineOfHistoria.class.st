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
		self redistick: spec.
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
		]
]

{ #category : 'external projects' }
BaselineOfHistoria >> redistick: spec [
	spec
		baseline: 'RediStick'
		with: [ spec
				repository: 'github://mumez/RediStick/repository';
				loads: 'default' ]
]
