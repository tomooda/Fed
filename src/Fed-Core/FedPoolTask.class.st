Class {
	#name : 'FedPoolTask',
	#superclass : 'Object',
	#instVars : [
		'pollingInterval'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'evaluating' }
FedPoolTask class >> value: anObject [

	^ self new value: anObject
]

{ #category : 'class access' }
FedPoolTask class >> workerPoolClass [

	^ self subclassResponsibility
]

{ #category : 'reading-writing' }
FedPoolTask >> cleanUp: aTaskReference [

	^ self workerPoolClass cleanUp: aTaskReference
]

{ #category : 'defaults' }
FedPoolTask >> defaultPollingInterval [

	^ 100 milliSeconds
]

{ #category : 'initialization' }
FedPoolTask >> initialize [

	super initialize.
	pollingInterval := self defaultPollingInterval
]

{ #category : 'reading-writing' }
FedPoolTask >> newRequest [

	| id tmp |
	[
		id := self poolDirectory / UUID new asInteger asString.
		id exists ] whileTrue.
	id ensureCreateFile.
	tmp := self withRequestExtension: id.
	[
		([ id renameTo: tmp basename ]
			 on: FileExists
			 do: [ :ex | ex return: nil ]) isNil ] whileTrue: [
		tmp := self withRequestExtension: self poolDirectory / UUID new asInteger asString ].
	^ id withoutExtension
]

{ #category : 'accessing' }
FedPoolTask >> pollingInterval [

	^ pollingInterval
]

{ #category : 'accessing' }
FedPoolTask >> pollingInterval: anObject [

	pollingInterval := anObject
]

{ #category : 'accessing' }
FedPoolTask >> poolDirectory [

	^ self workerPoolClass poolDirectory
]

{ #category : 'reading-writing' }
FedPoolTask >> readResponse: aFileReference [

	^ self subclassResponsibility
]

{ #category : 'evaluating' }
FedPoolTask >> value: anObject [

	| taskReference |
	taskReference := self newRequest.
	^ [
		  | responseReference |
		  self writeRequest: anObject to: (self withRequestExtension: taskReference).
		  responseReference := self withResponseExtension: taskReference.
		  [ responseReference exists ] whileFalse: [ self wait ].
		  self readResponse: responseReference ] ensure: [ self cleanUp: taskReference ]
]

{ #category : 'waiting' }
FedPoolTask >> wait [

	pollingInterval ifNotNil: #wait
]

{ #category : 'accessing' }
FedPoolTask >> withInprogressExtension: aFileReference [

	^ self workerPoolClass withInprogressExtension: aFileReference
]

{ #category : 'accessing' }
FedPoolTask >> withRequestExtension: aFileReference [

	^ self workerPoolClass withRequestExtension: aFileReference
]

{ #category : 'accessing' }
FedPoolTask >> withResponseExtension: aFileReference [

	^ self workerPoolClass withResponseExtension: aFileReference
]

{ #category : 'class access' }
FedPoolTask >> workerPoolClass [
	^ self class workerPoolClass
]

{ #category : 'reading-writing' }
FedPoolTask >> writeRequest: anObject to: aFileReference [

	^ self subclassResponsibility
]
