Class {
	#name : #GtWaylandClipboard,
	#superclass : #GtClipboard,
	#instVars : [
		'waylandDisplay'
	],
	#classVars : [
		'UseXclip'
	],
	#category : #'GToolkit-Clipboard-Clipboard'
}

{ #category : #initialize }
GtWaylandClipboard class >> beDefault [

	self new beDefault
]

{ #category : #configuration }
GtWaylandClipboard class >> clearUseXclip [
	"Set the UseXclip flag"

	UseXclip := false
]

{ #category : #initialize }
GtWaylandClipboard class >> initialize [

	SessionManager default registerUserClassNamed: self name.
]

{ #category : #configuration }
GtWaylandClipboard class >> setUseXclip [
	"Set the UseXclip flag"

	UseXclip := true
]

{ #category : #initialize }
GtWaylandClipboard class >> startUp: resuming [
	| platformEnvironment |

	resuming ifFalse: [ ^ self ].
	platformEnvironment := OSPlatform current environment.
	platformEnvironment
		at: 'WAYLAND_DISPLAY'
		encoding: platformEnvironment defaultEncoding
		ifPresent: [ :display | self new
			waylandDisplay: display;
			beDefault ]
]

{ #category : #testing }
GtWaylandClipboard class >> useXclip [
	"Answer a boolean indicating whether to use xclip to copy to the clipboard, instead of wl-copy"

	^ UseXclip ifNil: [ ^ false ]
]

{ #category : #private }
GtWaylandClipboard >> addWaylandEnvTo: builder [
	| envDictionary |

	envDictionary := Smalltalk os environment asDictionary.
	builder env: 'WAYLAND_DISPLAY' value: waylandDisplay.
	envDictionary keysAndValuesDo: [ :key :value |
		(key includesSubstring: 'WAYLAND') ifTrue:
			[ builder env: key value: value ] ].
]

{ #category : #private }
GtWaylandClipboard >> primitiveClipboardText [
	"Answer the current clipboard text.
	See #primitiveClipboardText: for more details about platform compatibility."
	| builder proc stdout status |

	builder := GtExternalProcessBuilder new
		command: 'wl-paste';
		pipeStdout.
	self addWaylandEnvTo: builder.
	proc := builder spawn.
	status := proc wait.
	status isSuccess ifFalse: [ ^ super primitiveClipboardText ].
	stdout := builder output stdout trimRight.
	^ stdout
]

{ #category : #accessing }
GtWaylandClipboard >> primitiveClipboardText: aString [
	"Set the current clipboard text to the given string.
	It appears that hyprland works with the wayland specific utilities wl-copy and wl-paste.
	While Gnome attemps to be more compatible with X-Windows, so uses xclip and whatever rust does."
	| status |

	mutex criticalReleasingOnError: [ | builder proc |
		builder := GtExternalProcessBuilder new
			command: 'wl-copy';
			pipeStdin.
		self addWaylandEnvTo: builder.
		proc := builder spawn.
		proc stdin
			nextPutAll: aString withUnixLineEndings;
			close.
		status := proc wait.
		status isSuccess ifFalse:
			[ status := self primitiveXclipClipboardText: aString ] ].
	self assert: status isSuccess.
]

{ #category : #private }
GtWaylandClipboard >> primitiveXclipClipboardText: aString [
	"Set the current clipboard text to the given string."

	^ mutex criticalReleasingOnError: [ | builder proc |
		builder := GtExternalProcessBuilder new
			command: 'xclip';
			arguments: { '-sel'. 'c'. };
			pipeStdin.
		proc := builder spawn.
		proc stdin
			nextPutAll: aString withUnixLineEndings;
			close.
		"proc wait answers the status"
		proc wait ]
]

{ #category : #accessing }
GtWaylandClipboard >> waylandDisplay [
	^ waylandDisplay
]

{ #category : #accessing }
GtWaylandClipboard >> waylandDisplay: anObject [
	waylandDisplay := anObject
]
