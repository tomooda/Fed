Class {
	#name : 'FedWorker',
	#superclass : 'ClapApplication',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'accessing' }
FedWorker class >> commandName [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
FedWorker class >> commandSpec [

	^ (ClapCommandSpec id: self commandName asSymbol)
		  description: self description;
		  commandClass: self;
		  addHelp;
		  yourself
]

{ #category : 'accessing' }
FedWorker class >> description [

	^ self subclassResponsibility
]

{ #category : 'testing' }
FedWorker class >> isAbstract [

	^ self == FedWorker
]

{ #category : 'spawning' }
FedWorker class >> spawn [

	^ self spawnWithArguments: #(  )
]

{ #category : 'spawning' }
FedWorker class >> spawnWith: aString [

	^ self spawnWithArguments: { aString }
]

{ #category : 'spawning' }
FedWorker class >> spawnWithArguments: anArrayOfString [

	| pid |
	pid := FedLibC spawn: {
			       Smalltalk vm fullPath.
			       '--headless'.
			       Smalltalk imagePath.
			       self commandName } , anArrayOfString.
	^ (FedExternalPharo pid: pid)
		  commandName: self commandName;
		  commandArguments: anArrayOfString;
		  yourself
]

{ #category : 'execution' }
FedWorker >> doOneTask [

	^ self subclassResponsibility
]

{ #category : 'execution' }
FedWorker >> process: anObject [

	^ self subclassResponsibility
]
