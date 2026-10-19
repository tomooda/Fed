Class {
	#name : 'FedOneShotWorkerWithOneCommandlineArgNoReturn',
	#superclass : 'FedOneShotWorker',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'accessing' }
FedOneShotWorkerWithOneCommandlineArgNoReturn class >> argDescription [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
FedOneShotWorkerWithOneCommandlineArgNoReturn class >> commandSpec [

	^ super commandSpec
		  addPositional: #arg description: self argDescription;
		  yourself
]

{ #category : 'testing' }
FedOneShotWorkerWithOneCommandlineArgNoReturn class >> isAbstract [

	^ self == FedOneShotWorkerWithOneCommandlineArgNoReturn
]

{ #category : 'accessing' }
FedOneShotWorkerWithOneCommandlineArgNoReturn class >> value: anObject [

	^ self spawnWith: anObject asString
]

{ #category : 'reading-writing' }
FedOneShotWorkerWithOneCommandlineArgNoReturn >> readRequest [

	^ self positional: #arg
]

{ #category : 'reading-writing' }
FedOneShotWorkerWithOneCommandlineArgNoReturn >> writeResponse: anObject [

	
]
