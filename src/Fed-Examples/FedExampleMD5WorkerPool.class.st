Class {
	#name : 'FedExampleMD5WorkerPool',
	#superclass : 'FedWorkerPool',
	#traits : 'TFedJson',
	#classTraits : 'TFedJson classTrait',
	#category : 'Fed-Examples',
	#package : 'Fed-Examples'
}

{ #category : 'accessing' }
FedExampleMD5WorkerPool class >> commandName [

	^ 'md5worker'
]

{ #category : 'accessing' }
FedExampleMD5WorkerPool class >> description [

	^ 'compute MD5 digest of the specified file'
]

{ #category : 'accessing' }
FedExampleMD5WorkerPool class >> md5 [

	<commandline>
	^ self commandSpec
]

{ #category : 'accessing' }
FedExampleMD5WorkerPool class >> poolDirectory [

	^ (FileLocator localDirectory / 'fed-example-md5') ensureCreateDirectory
]

{ #category : 'execution' }
FedExampleMD5WorkerPool >> process: aString [

	^ aString asFileReference binaryReadStreamDo: [ :stream | (MD5NonPrimitive new hashMessage: stream contents) hex ]
]
