Class {
	#name : #BaselineOfGToolkitClipboard,
	#superclass : #BaselineOf,
	#classVars : [
		'PostLoaded'
	],
	#category : #BaselineOfGToolkitClipboard
}

{ #category : #baselines }
BaselineOfGToolkitClipboard >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			baseline: 'GToolkitInstaller' with: [ spec repository: 'github://feenkcom/gtoolkit-installer/src' ].
		spec
			baseline: 'GToolkitBoxer' with: [ spec repository: 'github://feenkcom/gtoolkit-boxer/boxer-bindings' ].
		spec
			postLoadDoIt: #'postLoadClipboard:';
			package: 'GToolkit-Clipboard' with: [ spec requires: #(GToolkitInstaller GToolkitBoxer) ] ]
]

{ #category : #baselines }
BaselineOfGToolkitClipboard >> postLoadClipboard: spec [
	(PostLoaded isNotNil and: [ PostLoaded ])
		ifTrue: [ ^ self ].

	PostLoaded := true.
	(self class environment at: #GtClipboardLibrary) install
]
