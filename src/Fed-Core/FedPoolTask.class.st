Class {
	#name : 'FedPoolTask',
	#superclass : 'FedTask',
	#traits : 'TFedPolling',
	#classTraits : 'TFedPolling classTrait',
	#instVars : [
		'pollingInterval'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'testing' }
FedPoolTask class >> isAbstract [

	^ self == FedPoolTask
]

{ #category : 'evaluating' }
FedPoolTask class >> value: anObject [

	^ self new value: anObject
]

{ #category : 'reading-writing' }
FedPoolTask >> cleanUp: aTaskReference [

	^ self workerClass cleanUp: aTaskReference
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
FedPoolTask >> poolDirectory [

	^ self workerClass poolDirectory
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

	self pollingInterval ifNotNil: #wait
]

{ #category : 'accessing' }
FedPoolTask >> withInprogressExtension: aFileReference [

	^ self workerClass withInprogressExtension: aFileReference
]

{ #category : 'accessing' }
FedPoolTask >> withRequestExtension: aFileReference [

	^ self workerClass withRequestExtension: aFileReference
]

{ #category : 'accessing' }
FedPoolTask >> withResponseExtension: aFileReference [

	^ self workerClass withResponseExtension: aFileReference
]

{ #category : 'reading-writing' }
FedPoolTask >> writeRequest: anObject to: aFileReference [

	^ self subclassResponsibility
]
