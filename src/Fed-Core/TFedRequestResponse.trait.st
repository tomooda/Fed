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
TFedRequestResponse classSide >> withRequestExtension: aFileReference [

	^ aFileReference withExtension: self requestExtension
]

{ #category : 'utilities' }
TFedRequestResponse classSide >> withResponseExtension: aFileReference [

	^ aFileReference withExtension: self responseExtension
]

{ #category : 'defaults' }
TFedRequestResponse >> defaultPollingInterval [

	^ 100 milliSeconds
]

{ #category : 'reading-writing' }
TFedRequestResponse >> newRequest [

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

{ #category : 'waiting' }
TFedRequestResponse >> wait [

	^ self pollingInterval wait
]

{ #category : 'utilities' }
TFedRequestResponse >> withInprogressExtension: ref [

	^ self class withInprogressExtension: ref
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
