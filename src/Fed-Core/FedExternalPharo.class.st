Class {
	#name : 'FedExternalPharo',
	#superclass : 'Object',
	#instVars : [
		'pid',
		'commandName',
		'commandArguments'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'instance creation' }
FedExternalPharo class >> pid: anInteger [

	^ self new
		  pid: anInteger;
		  yourself
]

{ #category : 'accessing' }
FedExternalPharo >> commandArguments [

	^ commandArguments
]

{ #category : 'accessing' }
FedExternalPharo >> commandArguments: anArrayOfString [

	commandArguments := anArrayOfString
]

{ #category : 'accessing' }
FedExternalPharo >> commandName [

	^ commandName
]

{ #category : 'accessing' }
FedExternalPharo >> commandName: aString [

	commandName := aString
]

{ #category : 'accessing' }
FedExternalPharo >> pid [

	^ pid
]

{ #category : 'accessing' }
FedExternalPharo >> pid: anInteger [

	pid := anInteger
]

{ #category : 'printing' }
FedExternalPharo >> printOn: aStream [

	aStream
		nextPutAll: 'pharo ';
		nextPutAll: (commandName ifNil: [ '-' ]).
	commandArguments ifNotNil: [
			commandArguments do: [ :arg |
					aStream
						space;
						nextPutAll: arg asString ] ].
	aStream nextPutAll: ' (pid:'.
	pid printOn: aStream.
	aStream nextPut: $)
]
