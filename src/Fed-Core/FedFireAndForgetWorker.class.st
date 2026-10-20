Class {
	#name : 'FedFireAndForgetWorker',
	#superclass : 'FedWorker',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'accessing' }
FedFireAndForgetWorker class >> argDescription [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
FedFireAndForgetWorker class >> commandSpec [

	^ super commandSpec
		  addPositional: #arg description: self argDescription;
		  yourself
]

{ #category : 'testing' }
FedFireAndForgetWorker class >> isAbstract [

	^ self == FedFireAndForgetWorker
]

{ #category : 'accessing' }
FedFireAndForgetWorker class >> value: anObject [

	^ self spawnWith: anObject asString
]

{ #category : 'execution' }
FedFireAndForgetWorker >> doOneTask [

	^ self process: self readRequest
]

{ #category : 'execution' }
FedFireAndForgetWorker >> execute [

	self doOneTask
]

{ #category : 'reading-writing' }
FedFireAndForgetWorker >> readRequest [

	^ self positional: #arg
]
