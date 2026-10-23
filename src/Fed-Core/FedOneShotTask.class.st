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

{ #category : 'accessing' }
FedOneShotTask >> poolDirectory [

	^ self workerClass poolDirectory
]

{ #category : 'evaluating' }
FedOneShotTask >> value: anObject [

	| taskReference |
	taskReference := self newTaskReference.
	^ [
		  self write: anObject to: (self withRequestExtension: taskReference).
		  self workerClass newWorker: taskReference.
		  self pollAndRead: (self withResponseExtension: taskReference) ] ensure: [ self cleanUpFiles: taskReference ]
]
