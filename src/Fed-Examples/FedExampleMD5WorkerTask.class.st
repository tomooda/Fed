Class {
	#name : 'FedExampleMD5WorkerTask',
	#superclass : 'FedPoolTask',
	#traits : 'TFedJson',
	#classTraits : 'TFedJson classTrait',
	#category : 'Fed-Examples',
	#package : 'Fed-Examples'
}

{ #category : 'examples' }
FedExampleMD5WorkerTask class >> exampleWithFedWorkerPool [

	([
		 | semaphore |
		 semaphore := Semaphore new.
		 4 timesRepeat: [ self workerClass newWorker ].
		 4 timesRepeat: [
				 [
					 self value: FileLocator changes fullName.
					 semaphore signal ] fork ].
		 4 timesRepeat: [ semaphore wait ].
		 self workerClass close ] millisecondsToRun / 1000.0) inspect
]

{ #category : 'examples' }
FedExampleMD5WorkerTask class >> exampleWithGreenThreads [

	([
		 | semaphore block |
		 semaphore := Semaphore new.
		 block := [ :aString |
		          aString asFileReference binaryReadStreamDo: [ :stream | (MD5NonPrimitive new hashMessage: stream contents) hex ] ].
		 4 timesRepeat: [
				 [
					 block value: FileLocator changes fullName.
					 semaphore signal ] fork ].
		 4 timesRepeat: [ semaphore wait ] ] millisecondsToRun / 1000.0) inspect
]

{ #category : 'class access' }
FedExampleMD5WorkerTask class >> workerClass [

	^ FedExampleMD5WorkerPool
]
