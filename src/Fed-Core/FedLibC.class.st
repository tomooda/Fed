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
	#pools : [
		'LibCTypes'
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
FedLibC class >> rename: oldPathString to: newPathString [

	^ self uniqueInstance rename: oldPathString to: newPathString
]

{ #category : 'operations' }
FedLibC class >> spawn: anArrayOfString [

	^ self uniqueInstance spawn: anArrayOfString
]

{ #category : 'private - rename' }
FedLibC >> LINUX_RENAME_NOREPLACE [

	^ 1
]

{ #category : 'private - rename' }
FedLibC >> MAC_RENAME_EXCL [

	^ 4
]

{ #category : 'private - rename' }
FedLibC >> linux_renameat2: olddirfd oldpath: oldpath newdirfd: newdirfd newpath: newpath flags: flags [
	^ self ffiCall: #(int renameat2(int olddirfd, String oldpath, int newdirfd, String newpath, uint flags))
]

{ #category : 'private - accessing' }
FedLibC >> macLibraryName [
	^ 'libc.dylib'
]

{ #category : 'private - rename' }
FedLibC >> mac_renamex_np: oldPath to: newPath flags: flags [
	^ self ffiCall: #(int renamex_np(String oldPath, String newPath, uint flags))
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

	 ^self ffiCall: #(pid_t getpid(void))
]

{ #category : 'private - spawn' }
FedLibC >> posix_spawn: path argv: argv env: env [

	| pid |
	pid := FedWriteBackIntValue new.
	self
		prim_posix_spawn: pid
		path: path
		argv: argv
		env: env.
	^ pid value
]

{ #category : 'private - spawn' }
FedLibC >> prim_posix_spawn: pid path: path argv: argv env: env [
	^ self ffiCall: #(int posix_spawn(FedWriteBackIntValue pid ,  String path , nil , nil , void* argv, void *env))
]

{ #category : 'operations' }
FedLibC >> rename: oldPath to: newPath [

	| platform |
	platform := OSPlatform current.
	platform isMacOSX ifTrue: [ ^ (self mac_renamex_np: oldPath to: newPath flags: self MAC_RENAME_EXCL) = 0 ].
	platform isLinux ifTrue: [
			^ (self
				   linux_renameat2: 0
				   oldpath: oldPath
				   newdirfd: 0
				   newpath: newPath
				   flags: self LINUX_RENAME_NOREPLACE) = 0 ].
	platform isWindows ifTrue: [ ^ (self win32_rename: oldPath to: newPath) = 0 ].
	self notYetImplemented
]

{ #category : 'operations' }
FedLibC >> spawn: anArrayOfString [

	^ self withArgv: anArrayOfString do: [ :argv |
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

{ #category : 'private - rename' }
FedLibC >> win32_rename: oldpath to: newpath [
	^ self ffiCall: #(int rename(String oldpath, String newpath))
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
