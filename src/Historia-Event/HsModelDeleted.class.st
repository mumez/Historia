Class {
	#name : 'HsModelDeleted',
	#superclass : 'HsCommandEvent',
	#category : 'Historia-Event',
	#package : 'Historia-Event'
}

{ #category : 'accessing' }
HsModelDeleted class >> typeName [
	^ #modelDeleted
]

{ #category : 'mutating' }
HsModelDeleted >> applyTo: targetModel [
	targetModel modelSpace deleteModelAt: self modelId
]

{ #category : 'accessing' }
HsModelDeleted >> modelId [
	^ self argsAt: 'modelId'
]

{ #category : 'accessing' }
HsModelDeleted >> modelId: anId [

	self argsAt: 'modelId' put: anId
]
