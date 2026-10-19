Class {
	#name : 'FedTask',
	#superclass : 'Object',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedTask class >> isAbstract [

	^ self == FedTask
]

{ #category : 'class access' }
FedTask class >> workerClass [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
FedTask >> value: anObject [

	^ self subclassResponsibility
]

{ #category : 'class access' }
FedTask >> workerClass [
	^ self class workerClass
]
