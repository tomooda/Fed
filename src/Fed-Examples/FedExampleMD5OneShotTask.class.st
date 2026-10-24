Class {
	#name : 'FedExampleMD5OneShotTask',
	#superclass : 'FedOneShotTask',
	#traits : 'TFedJson',
	#classTraits : 'TFedJson classTrait',
	#category : 'Fed-Examples',
	#package : 'Fed-Examples'
}

{ #category : 'examples' }
FedExampleMD5OneShotTask class >> exampleWithFedSingleShotWorker [

	([
		 | semaphore |
		 semaphore := Semaphore new.
		 4 timesRepeat: [
				 [
					 self value: PharoFilesOpener sourcesFile fullName.
					 semaphore signal ] fork ].
		 4 timesRepeat: [ semaphore wait ] ] millisecondsToRun / 1000.0) inspect
]

{ #category : 'class access' }
FedExampleMD5OneShotTask class >> workerClass [

	^ FedExampleMD5OneShotWorker
]
