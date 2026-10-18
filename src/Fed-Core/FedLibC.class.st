"
I'm a module defining access to standard LibC. 
I'm available under Linux and OSX.
Under windows I provide similar functionality through the functions defined in msvcrt.dll
"
Class {
	#name : 'FedLibC',
	#superclass : 'FFILibrary',
	#classVars : [
		'P_DETACH',
		'P_NOWAIT',
		'P_NOWAITO',
		'P_OVERLAY',
		'P_WAIT'
	],
	#category : 'Fed-Core',
	#package : 'Fed-Core'
}

{ #category : 'initialization' }
FedLibC class >> initialize [

	P_WAIT := 0.
	P_NOWAIT := 1.
	P_OVERLAY := 2.
	P_NOWAITO := 3.
	P_DETACH := 4
]

{ #category : 'operations' }
FedLibC class >> pid [

	^ self uniqueInstance pid
]

{ #category : 'operations' }
FedLibC class >> spawn: anArrayOfString [

	^ self uniqueInstance spawn: anArrayOfString
]

{ #category : 'private - accessing' }
FedLibC >> macLibraryName [
	^ 'libc.dylib'
]

{ #category : 'operations' }
FedLibC >> pid [

	^ OSPlatform current isWindows
		  ifTrue: [ self win32_GetCurrentProcessId ]
		  ifFalse: [ self posix_getpid ]
]

{ #category : 'private - pid' }
FedLibC >> posix_getpid [
	"Get PID of current process."

	 ^self ffiCall: #(int getpid(void))
]

{ #category : 'private - spawn' }
FedLibC >> posix_spawn: path argv: argv env: env [

	^ self ffiCall: #(int posix_spawn(nil ,  String path , nil , nil , void* argv, void *env))
]

{ #category : 'operations' }
FedLibC >> spawn: anArrayOfString [

	self withArgv: anArrayOfString do: [ :argv |
			OSPlatform current isWindows
				ifTrue: [ self win32_spawnvp: P_NOWAIT cmdname: anArrayOfString first argv: argv ]
				ifFalse: [
						self
							withArgv: (Array streamContents: [ :stream |
										 OSEnvironment current keysAndValuesDo: [ :key :value |
												 stream nextPut: ('=' join: {
															  key.
															  value }) ] ])
							do: [ :env | self posix_spawn: anArrayOfString first argv: argv env: env ] ] ]
]

{ #category : 'operations' }
FedLibC >> spawn: aFileReference arguments: anArrayOfString [

	| arg0 |
	arg0 := aFileReference fullName.
	self withArgv: (anArrayOfString copyWithFirst: arg0) do: [ :argv |
			OSPlatform current isWindows
				ifTrue: [ self win32_spawnvp: P_NOWAIT cmdname: arg0 argv: argv ]
				ifFalse: [
						self
							withArgv: (Array streamContents: [ :stream |
										 OSEnvironment current keysAndValuesDo: [ :key :value |
												 stream nextPut: ('=' join: {
															  key.
															  value }) ] ])
							do: [ :env | self posix_spawn: arg0 argv: argv env: env ] ] ]
]

{ #category : 'private - accessing' }
FedLibC >> unixLibraryName [
	^ 'libc.so.6'
]

{ #category : 'private - accessing' }
FedLibC >> win32LibraryName [
	"While this is not a 'libc' properly, msvcrt has the functions we are defining here"
	^ 'msvcrt.dll'
]

{ #category : 'private - pid' }
FedLibC >> win32_GetCurrentProcessId [
	"Get PID of current process."

	 ^self ffiCall: #(uint32 GetCurrentProcessId(void))
]

{ #category : 'private - spawn' }
FedLibC >> win32_spawnvp: mode cmdname: cmdname argv: argv [

	^ self ffiCall: #(int64 _spawnvp(int mode, String cmdname, void* argv))
]

{ #category : 'private - argv' }
FedLibC >> withArgv: strings do: block [

	| externalArray |
	externalArray := FFIExternalArray externalNewType: 'char*' size: strings size + 1.
	strings withIndexDo: [ :string :stringIndex |
			| byteArray externalAddress |
			byteArray := string utf8Encoded.
			externalAddress := ExternalAddress allocate: byteArray size + 1.
			byteArray withIndexDo: [ :byte :byteIndex | externalAddress byteAt: byteIndex put: byte ].
			externalAddress byteAt: byteArray size + 1 put: 0.
			externalArray at: stringIndex put: externalAddress ].
	externalArray at: strings size + 1 put: ExternalAddress null.
	^ [ block value: externalArray ] ensure: [
			  1 to: strings size do: [ :index | (externalArray at: index) free ].
			  externalArray free ]
]
