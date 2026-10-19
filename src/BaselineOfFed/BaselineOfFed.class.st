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
		package: 'Fed-Examples' with: [ spec requires: #( 'Fed-Core' ) ];
		group: 'default' with: #( 'Fed-Core' 'Fed-Examples' )
]
