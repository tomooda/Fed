Class {
	#name : 'FedOneShotTask',
	#superclass : 'FedTask',
	#traits : 'TFedRequestResponse',
	#classTraits : 'TFedRequestResponse classTrait',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedOneShotTask class >> isAbstract [

	^ self == FedOneShotTask
]

{ #category : 'reading-writing' }
FedOneShotTask >> cleanUp: aTaskReference [

	^ self workerClass cleanUp: aTaskReference
]

{ #category : 'accessing' }
FedOneShotTask >> poolDirectory [

	^ self workerClass poolDirectory
]

{ #category : 'accessing' }
FedOneShotTask >> value: anObject [

	| taskReference |
	taskReference := self newRequest.
	^ [
		  self write: anObject to: (self withRequestExtension: taskReference).
		  self workerClass newWorker: taskReference.
		  self pollAndRead: (self withResponseExtension: taskReference) ] ensure: [ self cleanUp: taskReference ]
]
