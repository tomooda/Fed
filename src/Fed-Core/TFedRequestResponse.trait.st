Trait {
	#name : 'TFedRequestResponse',
	#instVars : [
		'pollingInterval'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'accessing' }
TFedRequestResponse classSide >> inprogressExtension [

	^ 'inprogress'
]

{ #category : 'accessing' }
TFedRequestResponse classSide >> lockExtension [

	^ 'lock'
]

{ #category : 'accessing' }
TFedRequestResponse classSide >> requestExtension [

	^ 'request'
]

{ #category : 'accessing' }
TFedRequestResponse classSide >> responseExtension [

	^ 'response'
]

{ #category : 'utilities' }
TFedRequestResponse classSide >> withInprogressExtension: aFileReference [

	^ aFileReference withExtension: self inprogressExtension
]

{ #category : 'utilities' }
TFedRequestResponse classSide >> withLockExtension: aFileReference [

	^ aFileReference withExtension: self lockExtension
]

{ #category : 'utilities' }
TFedRequestResponse classSide >> withRequestExtension: aFileReference [

	^ aFileReference withExtension: self requestExtension
]

{ #category : 'utilities' }
TFedRequestResponse classSide >> withResponseExtension: aFileReference [

	^ aFileReference withExtension: self responseExtension
]

{ #category : 'reading-writing' }
TFedRequestResponse >> cleanUpFiles: aTaskReference [

	(aTaskReference parent filesMatching: aTaskReference basename , '.*') do: [ :ref | ref ensureDelete ]
]

{ #category : 'defaults' }
TFedRequestResponse >> defaultPollingInterval [

	^ 100 milliSeconds
]

{ #category : 'reading-writing' }
TFedRequestResponse >> fetchTask: extension1 as: extension2 [

	(self poolDirectory filesMatching: '*.' , extension1) do: [ :ref |
		(self rename: ref to: (ref withExtension: extension2)) ifTrue: [ ^ ref withoutExtension ] ].
	^ nil
]

{ #category : 'reading-writing' }
TFedRequestResponse >> fetchTaskFromQueue: extension1 as: extension2 [

	(self poolDirectory filesMatching: '*.' , extension1) ifNotEmpty: [ :files |
			((files collect: [ :ref | ref basenameWithoutExtension asInteger -> ref ]) sorted: #key ascending) do: [ :assoc |
					| ref |
					ref := assoc key.
					(self rename: ref to: (ref withExtension: extension2)) ifTrue: [ ^ ref withoutExtension ] ] ].
	^ nil
]

{ #category : 'utilities' }
TFedRequestResponse >> inprogressExtension [

	^ self class inprogressExtension
]

{ #category : 'utilities' }
TFedRequestResponse >> lockExtension [

	^ self class lockExtension
]

{ #category : 'reading-writing' }
TFedRequestResponse >> newTaskReference [

	| id lock |
	[
		id := self poolDirectory / Time microsecondClockValue asString.
		id exists ] whileTrue.
	id ensureCreateFile.
	lock := self withLockExtension: id.
	[ self rename: id to: lock ] whileFalse: [
		lock := self withLockExtension: self poolDirectory / Time microsecondClockValue asString ].
	^ lock withoutExtension
]

{ #category : 'reading-writing' }
TFedRequestResponse >> pollAndRead: aFileReference [

	[ aFileReference exists ] whileFalse: [ self wait ].
	^ self read: aFileReference
]

{ #category : 'accessing' }
TFedRequestResponse >> pollingInterval [

	^ pollingInterval ifNil: [ pollingInterval := self defaultPollingInterval ]
]

{ #category : 'accessing' }
TFedRequestResponse >> pollingInterval: aDuration [

	pollingInterval := aDuration
]

{ #category : 'accessing' }
TFedRequestResponse >> poolDirectory [

	^ self subclassResponsibility
]

{ #category : 'reading-writing' }
TFedRequestResponse >> read: aFileReference [

	^ self subclassResponsibility
]

{ #category : 'reading-writing' }
TFedRequestResponse >> rename: aFileReference to: anotherFileReference [

	^ FedLibC rename: aFileReference fullName to: anotherFileReference fullName
]

{ #category : 'utilities' }
TFedRequestResponse >> requestExtension [

	^ self class requestExtension
]

{ #category : 'utilities' }
TFedRequestResponse >> responseExtension [

	^ self class responseExtension
]

{ #category : 'waiting' }
TFedRequestResponse >> wait [

	^ self pollingInterval wait
]

{ #category : 'utilities' }
TFedRequestResponse >> withInprogressExtension: ref [

	^ self class withInprogressExtension: ref
]

{ #category : 'utilities' }
TFedRequestResponse >> withLockExtension: ref [

	^ self class withLockExtension: ref
]

{ #category : 'utilities' }
TFedRequestResponse >> withRequestExtension: ref [

	^ self class withRequestExtension: ref
]

{ #category : 'utilities' }
TFedRequestResponse >> withResponseExtension: ref [

	^ self class withResponseExtension: ref
]

{ #category : 'reading-writing' }
TFedRequestResponse >> write: anObject to: aFileReference [

	^ self subclassResponsibility
]
