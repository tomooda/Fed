Class {
	#name : 'FedPoolTask',
	#superclass : 'FedTask',
	#traits : 'TFedRequestResponse',
	#classTraits : 'TFedRequestResponse classTrait',
	#instVars : [
		'pollingInterval'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedPoolTask class >> isAbstract [

	^ self == FedPoolTask
]

{ #category : 'reading-writing' }
FedPoolTask >> cleanUp: aTaskReference [

	^ self workerClass cleanUp: aTaskReference
]

{ #category : 'accessing' }
FedPoolTask >> poolDirectory [

	^ self workerClass poolDirectory
]

{ #category : 'evaluating' }
FedPoolTask >> value: anObject [

	| taskReference |
	taskReference := self newRequest.
	^ [
		  self write: anObject to: (self withRequestExtension: taskReference).
		  self pollAndRead: (self withResponseExtension: taskReference) ] ensure: [ self cleanUp: taskReference ]
]

{ #category : 'waiting' }
FedPoolTask >> wait [

	self pollingInterval ifNotNil: #wait
]

{ #category : 'utilities' }
FedPoolTask >> withInprogressExtension: aFileReference [

	^ self workerClass withInprogressExtension: aFileReference
]

{ #category : 'utilities' }
FedPoolTask >> withRequestExtension: aFileReference [

	^ self workerClass withRequestExtension: aFileReference
]

{ #category : 'utilities' }
FedPoolTask >> withResponseExtension: aFileReference [

	^ self workerClass withResponseExtension: aFileReference
]
