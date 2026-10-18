Class {
	#name : 'BaselineOfFed',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFed',
	#package : 'BaselineOfFed'
}

{ #category : 'baselines' }
BaselineOfFed >> baseline: spec [

	<baseline>
	spec
		package: 'Fed-Core' with: [ spec requires: #(  ) ];
		group: 'default' with: #( 'Fed-Core' )
]
