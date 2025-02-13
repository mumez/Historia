Class {
	#name : 'HsBaseTestCase',
	#superclass : 'TestCase',
	#category : 'Historia-Tests',
	#package : 'Historia-Tests'
}

{ #category : 'private' }
HsBaseTestCase >> sleep: milliseconds [
	(Delay forMilliseconds: milliseconds) wait
]

{ #category : 'private' }
HsBaseTestCase >> spaces: modelSpaces do: aBlock [
	aBlock ensure: [ modelSpaces do: [ :each | each releaseStorages ] ]
]
