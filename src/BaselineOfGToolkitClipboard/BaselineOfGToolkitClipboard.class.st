Class {
	#name : #BaselineOfGToolkitClipboard,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitClipboard
}

{ #category : #baseline }
BaselineOfGToolkitClipboard >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:v0.8.48/boxer-bindings' ].
		spec
			baseline: 'GToolkitPhlowForRust' with: [
				spec repository: 'github://feenkcom/gt4phlow-rs:v0.6.0/src' ].

		spec package: 'GToolkit-Clipboard' with: [
			spec requires: #('GToolkitBoxer' 'GToolkitPhlowForRust') ].
	]
]
