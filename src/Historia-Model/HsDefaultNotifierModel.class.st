Class {
	#name : 'HsDefaultNotifierModel',
	#superclass : 'HsModel',
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'defaults' }
HsDefaultNotifierModel class >> defaultId [
	^ '__defaultNotifier'
]

{ #category : 'acccessing' }
HsDefaultNotifierModel >> id [
	id ifNil: [ id := self class defaultId ].
	^ id
]
