Class {
	#name : 'FedJsonWorkerPool',
	#superclass : 'FedWorkerPool',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedJsonWorkerPool class >> isAbstract [

	^ self == FedJsonWorkerPool
]

{ #category : 'reading-writing' }
FedJsonWorkerPool >> readRequest: aFileReference [

	^ aFileReference readStreamDo: [ :stream | STONJSON fromStream: stream ]
]

{ #category : 'reading-writing' }
FedJsonWorkerPool >> writeResponse: anObject to: aFileReference [

	aFileReference writeStreamDo: [ :stream | STONJSON put: anObject onStream: stream ]
]
