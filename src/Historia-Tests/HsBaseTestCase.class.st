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
