Class {
	#name : 'FedOneShotWorker',
	#superclass : 'FedWorker',
	#traits : 'TFedRequestResponse',
	#classTraits : 'TFedRequestResponse classTrait',
	#instVars : [
		'taskReference'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'reading-writing' }
FedOneShotWorker class >> cleanUp: aTaskReference [

	(self withResponseExtension: aTaskReference) ensureDelete.
	(self withRequestExtension: aTaskReference) ensureDelete
]

{ #category : 'accessing' }
FedOneShotWorker class >> commandSpec [

	^ super commandSpec
		  addPositional: #taskReference description: 'A fullpath to the request file without extension';
		  yourself
]

{ #category : 'testing' }
FedOneShotWorker class >> isAbstract [

	^ self == FedOneShotWorker
]

{ #category : 'running' }
FedOneShotWorker class >> newWorker: aTaskReference [

	^ self spawnWith: aTaskReference fullName
]

{ #category : 'accessing' }
FedOneShotWorker class >> poolDirectory [

	^ self subclassResponsibility
]

{ #category : 'execution' }
FedOneShotWorker >> doOneTask [

	^ self writeResponse: (self process: self readRequest)
]

{ #category : 'execution' }
FedOneShotWorker >> execute [

	self doOneTask
]

{ #category : 'accessing' }
FedOneShotWorker >> poolDirectory [

	^ self taskReference parent
]

{ #category : 'reading-writing' }
FedOneShotWorker >> readRequest [

	^ self read: (self withRequestExtension: self taskReference)
]

{ #category : 'accessing' }
FedOneShotWorker >> taskReference [

	^ taskReference ifNil: [ taskReference := (self positional: #taskReference) asFileReference ]
]

{ #category : 'reading-writing' }
FedOneShotWorker >> writeResponse: anObject [

	^ self write: anObject to: (self withResponseExtension: self taskReference)
]
