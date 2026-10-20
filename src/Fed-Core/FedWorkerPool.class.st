Class {
	#name : 'FedWorkerPool',
	#superclass : 'FedWorker',
	#traits : 'TFedRequestResponse',
	#classTraits : 'TFedRequestResponse classTrait',
	#instVars : [
		'lastModificationTime',
		'poolDirectory'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'reading-writing' }
FedWorkerPool class >> cleanUp: aTaskReference [

	(self withResponseExtension: aTaskReference) ensureDelete.
	(self withRequestExtension: aTaskReference) ensureDelete.
	(self withInprogressExtension: aTaskReference) ensureDelete
]

{ #category : 'running' }
FedWorkerPool class >> close [

	self poolDirectory ensureDeleteAll
]

{ #category : 'accessing' }
FedWorkerPool class >> commandSpec [

	^ super commandSpec
		  addPositional: #poolDirectory
		  description: 'A fullpath to the pool directory to fetch <taskid>.request and write <taskid>.response';
		  addFlagWithPositional: #interval
		  description: 'The polling interval in milli-seconds to fetch a new request in the pool directory';
		  yourself
]

{ #category : 'testing' }
FedWorkerPool class >> isAbstract [

	^ self == FedWorkerPool
]

{ #category : 'running' }
FedWorkerPool class >> newWorker [

	^ self spawnWith: (self poolDirectory
			   ensureCreateDirectory;
			   fullName)
]

{ #category : 'accessing' }
FedWorkerPool class >> poolDirectory [

	^ self subclassResponsibility
]

{ #category : 'defaults' }
FedWorkerPool >> defaultPollingInterval [

	^ ((self
		    positional: #interval
		    ifPresent: [ :str |
				    (str allSatisfy: #digit)
					    ifTrue: [ str asInteger ]
					    ifFalse: [ nil ] ]
		    ifAbsent: [ nil ]) ifNil: [ 100 ]) milliSeconds
]

{ #category : 'execution' }
FedWorkerPool >> doOneTask [

	self fetchTask
		ifNotNil: [ :taskRef |
				| request response |
				request := self read: (self withRequestExtension: taskRef).
				response := self process: request.
				self write: response to: (self withResponseExtension: taskRef) ]
		ifNil: [ self wait ]
]

{ #category : 'execution' }
FedWorkerPool >> execute [

	[ self poolDirectory isDirectory ] whileTrue: [ self doOneTask ]
]

{ #category : 'execution' }
FedWorkerPool >> fetchTask [

	(lastModificationTime isNil or: [ lastModificationTime < self poolDirectory modificationTime ]) ifTrue: [
			| id |
			id := nil.
			(self poolDirectory filesMatching: '*.' , self class requestExtension) do: [ :ref |
					((self withInprogressExtension: ref) exists not and: [ ref exists ]) ifTrue: [
							id ifNil: [
									[
										id := self poolDirectory / UUID new asInteger asString.
										id exists ] whileTrue.
									id ensureCreateFile ].
							(FedLibC rename: id fullName to: (self withInprogressExtension: ref) fullName) ifTrue: [ ^ ref withoutExtension ] ] ].
			id ifNotNil: [ id ensureDelete ] ].
	^ nil
]

{ #category : 'accessing' }
FedWorkerPool >> poolDirectory [

	^ poolDirectory ifNil: [ poolDirectory := (self positional: #poolDirectory) asFileReference ]
]
