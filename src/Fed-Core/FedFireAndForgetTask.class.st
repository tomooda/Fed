Class {
	#name : 'FedFireAndForgetTask',
	#superclass : 'FedTask',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedFireAndForgetTask class >> isAbstract [

	^ self == FedFireAndForgetTask
]

{ #category : 'accessing' }
FedFireAndForgetTask >> value: anObject [

	^ self workerClass value: anObject
]
