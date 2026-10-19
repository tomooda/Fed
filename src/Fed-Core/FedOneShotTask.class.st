Class {
	#name : 'FedOneShotTask',
	#superclass : 'FedTask',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedOneShotTask class >> isAbstract [

	^ self == FedOneShotTask
]

{ #category : 'accessing' }
FedOneShotTask >> value: anObject [

	^ self workerClass value: anObject
]
