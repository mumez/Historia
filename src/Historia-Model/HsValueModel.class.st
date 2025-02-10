Class {
	#name : 'HsValueModel',
	#superclass : 'HsModel',
	#instVars : [
		'value'
	],
	#category : 'Historia-Model',
	#package : 'Historia-Model'
}

{ #category : 'applying' }
HsValueModel >> applyValue: newValue [
	value := newValue
]

{ #category : 'accessing' }
HsValueModel >> value [

	^ value
]

{ #category : 'mutating' }
HsValueModel >> value: newValue [
	self mutate: HsValueChanged using: [ :ev | ev value: newValue ]
]
