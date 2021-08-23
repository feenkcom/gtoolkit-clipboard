Class {
	#name : 'BaselineOfGToolkitClipboard',
	#superclass : 'BaselineOf',
	#classVars : [
		'PostLoaded'
	],
	#category : 'BaselineOfGToolkitClipboard'
}

{ #category : 'baseline' }
BaselineOfGToolkitClipboard >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec postLoadDoIt: #'postLoadClipboard:'.
		spec
			baseline: 'GToolkitInstaller' with: [
				spec repository: 'github://feenkcom/gtoolkit-installer:v0.8.7/src' ].
		spec
			baseline: 'GToolkitBoxer' with: [
				spec repository: 'github://feenkcom/gtoolkit-boxer:v0.8.17/boxer-bindings' ].

		spec package: 'GToolkit-Clipboard' with: [
			spec requires: #('GToolkitInstaller' 'GToolkitBoxer') ].
	]
]

{ #category : 'baselines' }
BaselineOfGToolkitClipboard >> postLoadClipboard: spec [
	(PostLoaded isNotNil and: [ PostLoaded ])
		ifTrue: [ ^ self ].

	PostLoaded := true.
	(self class environment at: #GtClipboardLibrary) install
]
