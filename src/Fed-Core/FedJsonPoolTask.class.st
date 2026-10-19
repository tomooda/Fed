Class {
	#name : 'FedJsonPoolTask',
	#superclass : 'FedPoolTask',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedJsonPoolTask class >> isAbstract [

	^ self == FedJsonPoolTask
]

{ #category : 'reading-writing' }
FedJsonPoolTask >> readResponse: aFileReference [

	^ aFileReference readStreamDo: [ :stream | STONJSON fromStream: stream ]
]

{ #category : 'reading-writing' }
FedJsonPoolTask >> writeRequest: anObject to: aFileReference [

	^ aFileReference writeStreamDo: [ :stream | STONJSON put: anObject onStream: stream ]
]
