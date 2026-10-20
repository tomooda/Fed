Class {
	#name : 'FedExampleMD5OneShotWorker',
	#superclass : 'FedOneShotWorker',
	#traits : 'TFedJson',
	#classTraits : 'TFedJson classTrait',
	#category : 'Fed-Examples',
	#package : 'Fed-Examples'
}

{ #category : 'accessing' }
FedExampleMD5OneShotWorker class >> commandName [

	^ 'md5oneshot'
]

{ #category : 'accessing' }
FedExampleMD5OneShotWorker class >> description [

	^ 'compute MD5 digest of the specified file'
]

{ #category : 'accessing' }
FedExampleMD5OneShotWorker class >> md5 [

	<commandline>
	^ self commandSpec
]

{ #category : 'accessing' }
FedExampleMD5OneShotWorker class >> poolDirectory [

	^ (FileLocator localDirectory / 'fed-example-md5') ensureCreateDirectory
]

{ #category : 'execution' }
FedExampleMD5OneShotWorker >> process: aString [

	^ aString asFileReference binaryReadStreamDo: [ :stream | (MD5NonPrimitive new hashMessage: stream contents) hex ]
]
