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
			baseline: 'GToolkitInstaller' with: [
				spec repository: 'github://feenkcom/gtoolkit-installer:v0.8.23/src' ].
		spec
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:v0.8.46/boxer-bindings' ].

		spec package: 'GToolkit-Clipboard' with: [
			spec requires: #('GToolkitInstaller' 'GToolkitBoxer') ].
	]
]
