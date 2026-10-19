Class {
	#name : 'FedExampleMD5Task',
	#superclass : 'FedJsonPoolTask',
	#category : 'Fed-Examples',
	#package : 'Fed-Examples'
}

{ #category : 'examples' }
FedExampleMD5Task class >> exampleWithFedWorkerPool [

	([
	| semaphore |
	semaphore := Semaphore new.
	self workerClass newWorker.
	self workerClass newWorker.
	[
		self value: FileLocator image fullName.
		semaphore signal ] fork.
	[
		self value: FileLocator image fullName.
		semaphore signal ] fork.
	2 timesRepeat: [ semaphore wait ].
	self workerClass close ] millisecondsToRun / 1000.0) inspect
]

{ #category : 'examples' }
FedExampleMD5Task class >> exampleWithGreenThreads [

	([
		 | semaphore block |
		 semaphore := Semaphore new.
		 block := [ :aString |
		          aString asFileReference binaryReadStreamDo: [ :stream | (MD5NonPrimitive new hashMessage: stream contents) hex ] ].
		 [
			 block value: FileLocator image fullName.
			 semaphore signal ] fork.
		 [
			 block value: FileLocator image fullName.
			 semaphore signal ] fork.
		 2 timesRepeat: [ semaphore wait ] ] millisecondsToRun / 1000.0) inspect
]

{ #category : 'class access' }
FedExampleMD5Task class >> workerClass [

	^ FedExampleMD5WorkerPool
]
