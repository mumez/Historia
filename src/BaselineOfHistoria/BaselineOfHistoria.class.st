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
		spec package: 'Historia-Core'.
		spec package: 'Historia-Codec'.
		spec package: 'Historia-Event'.
		spec package: 'Historia-Event-Processor'.
		spec package: 'Historia-Model'.
		spec package: 'Historia-Storage'.
		spec package: 'Historia-Tests'.
		spec package: 'Historia-Examples-Bank'.
		spec package: 'Historia-Examples-Bank-Tests'.
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
