Trait {
	#name : 'TFedPolling',
	#instVars : [
		'pollingInterval'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'defaults' }
TFedPolling >> defaultPollingInterval [

	^ 100 milliSeconds
]

{ #category : 'accessing' }
TFedPolling >> pollingInterval [

	^ pollingInterval ifNil: [ pollingInterval := self defaultPollingInterval ]
]

{ #category : 'accessing' }
TFedPolling >> pollingInterval: aDuration [

	pollingInterval := aDuration
]

{ #category : 'waiting' }
TFedPolling >> wait [

	^ self pollingInterval wait
]
