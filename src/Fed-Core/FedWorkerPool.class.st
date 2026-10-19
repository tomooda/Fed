Class {
	#name : 'FedWorkerPool',
	#superclass : 'FedWorker',
	#traits : 'TFedPolling',
	#classTraits : 'TFedPolling classTrait',
	#instVars : [
		'lastModificationTime',
		'_poolDirectory'
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

{ #category : 'accessing' }
FedWorkerPool class >> inprogressExtension [

	^ 'inprogress'
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

{ #category : 'accessing' }
FedWorkerPool class >> requestExtension [

	^ 'request'
]

{ #category : 'accessing' }
FedWorkerPool class >> responseExtension [

	^ 'response'
]

{ #category : 'accessing' }
FedWorkerPool class >> withInprogressExtension: aFileReference [

	^ aFileReference withExtension: self inprogressExtension
]

{ #category : 'accessing' }
FedWorkerPool class >> withRequestExtension: aFileReference [

	^ aFileReference withExtension: self requestExtension
]

{ #category : 'accessing' }
FedWorkerPool class >> withResponseExtension: aFileReference [

	^ aFileReference withExtension: self responseExtension
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
				request := self readRequest: (self withRequestExtension: taskRef).
				response := self process: request.
				self writeResponse: response to: (self withResponseExtension: taskRef) ]
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
					(self withInprogressExtension: ref) exists ifFalse: [
							id ifNil: [
									[
										id := self poolDirectory / UUID new asInteger asString.
										id exists ] whileTrue.
									id ensureCreateFile ].
							([ id renameTo: (self withInprogressExtension: ref) basename ]
								 on: FileExists
								 do: [ :ex | ex return: nil ]) ifNotNil: [ ^ ref withoutExtension ] ] ].
			id ifNotNil: [ id ensureDelete ] ].
	^ nil
]

{ #category : 'accessing' }
FedWorkerPool >> poolDirectory [

	^ _poolDirectory ifNil: [ _poolDirectory := (self positional: #poolDirectory) asFileReference ]
]

{ #category : 'reading-writing' }
FedWorkerPool >> readRequest: aFileReference [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
FedWorkerPool >> withInprogressExtension: ref [

	^ self class withInprogressExtension: ref
]

{ #category : 'accessing' }
FedWorkerPool >> withRequestExtension: ref [

	^ self class withRequestExtension: ref
]

{ #category : 'accessing' }
FedWorkerPool >> withResponseExtension: ref [

	^ self class withResponseExtension: ref
]

{ #category : 'reading-writing' }
FedWorkerPool >> writeResponse: anObject to: aFileReference [

	^ self subclassResponsibility
]
