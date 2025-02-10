Class {
	#name : 'HsOrderedCollectionModel',
	#superclass : 'HsModel',
	#instVars : [
		'values'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'mutating' }
HsOrderedCollectionModel >> add: newValue [
	self mutate: HsValueAdded using: [ :ev | ev value: newValue ]
]

{ #category : 'applying' }
HsOrderedCollectionModel >> applyAdd: newValue [
	self values add: newValue
]

{ #category : 'applying' }
HsOrderedCollectionModel >> applyRemove: newValue [
	self values remove: newValue
]

{ #category : 'converting' }
HsOrderedCollectionModel >> asArray [
	^ self values asArray
]

{ #category : 'testing' }
HsOrderedCollectionModel >> includes: value [
	^ self values includes: value
]

{ #category : 'mutating' }
HsOrderedCollectionModel >> remove: newValue [
	self mutate: HsValueRemoved using: [ :ev | ev value: newValue ]
]

{ #category : 'accessing' }
HsOrderedCollectionModel >> size [
	^ self values size
]

{ #category : 'accessing' }
HsOrderedCollectionModel >> values [

	^ values ifNil: [ values := OrderedCollection new ]
]

{ #category : 'accessing' }
HsOrderedCollectionModel >> values: anObject [

	values := anObject
]
