Class {
	#name : #BaselineOfGToolkitClipboard,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitClipboard
}

{ #category : #baseline }
BaselineOfGToolkitClipboard >> baseline: spec [
	<baseline> ""
	spec for: #'common' do: [
		spec 
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:main/boxer-bindings' ].

		spec package: 'GToolkit-Clipboard' with: [
				spec requires: #('GToolkitBoxer'). ]. ]
]
