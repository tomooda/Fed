Class {
	#name : 'FedOneShotWorker',
	#superclass : 'FedWorker',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedOneShotWorker class >> isAbstract [

	^ self == FedOneShotWorker
]

{ #category : 'accessing' }
FedOneShotWorker class >> value: anObject [

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

{ #category : 'reading-writing' }
FedOneShotWorker >> readRequest [

	^ self subclassResponsibility
]

{ #category : 'reading-writing' }
FedOneShotWorker >> writeResponse: anObject [

	^ self subclassResponsibility
]
