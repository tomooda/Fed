Trait {
	#name : 'TFedJson',
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'reading-writing' }
TFedJson >> read: aFileReference [

	^ aFileReference readStreamDo: [ :stream | STONJSON fromStream: stream ]
]

{ #category : 'reading-writing' }
TFedJson >> write: anObject to: aFileReference [

	^ aFileReference writeStreamDo: [ :stream | STONJSON put: anObject onStream: stream ]
]
