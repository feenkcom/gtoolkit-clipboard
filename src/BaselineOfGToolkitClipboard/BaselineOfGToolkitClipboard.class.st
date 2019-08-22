Class {
	#name : #BaselineOfGToolkitClipboard,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitClipboard
}

{ #category : #baselines }
BaselineOfGToolkitClipboard >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			baseline: 'GToolkitInstaller' with: [ spec repository: 'github://feenkcom/gtoolkit-installer/src' ].
		spec
			package: 'GToolkit-Clipboard' with: [ spec requires: #(GToolkitInstaller) ] ]
]
