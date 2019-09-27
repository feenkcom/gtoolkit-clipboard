Class {
	#name : #GtClipboardLibrary,
	#superclass : #FFILibrary,
	#classInstVars : [
		'MouseWheelScrollSpeed'
	],
	#category : #'GToolkit-Clipboard'
}

{ #category : #'library path' }
GtClipboardLibrary class >> ffiLibraryName [
	^ self
]

{ #category : #installation }
GtClipboardLibrary class >> install [
	<script: 'self install'>
	| installer |

	installer := GtLibraryInstaller new.
	installer library: 'Clipboard'.
	installer version: 'development'.
	installer icon: (Form extent: 1@1 depth: 32).
	installer binary: 'libClipboard'.
	installer url: 'https://dl.feenk.com/{library}/{platform}/{version}/{arch}/{binary}.{extension}'.
	installer works: [ GtClipboardLibrary uniqueInstance hasModule ].

	installer run
]

{ #category : #'accessing platform' }
GtClipboardLibrary >> detectLibrary: aFileName [
	^ ({ Smalltalk imageDirectory . Smalltalk vmDirectory . FileSystem workingDirectory }
		collect: [ :aPath | aPath asFileReference / aFileName ])
			detect: #exists
			ifFound: #fullName
			ifNone: [ aFileName ]
]

{ #category : #testing }
GtClipboardLibrary >> hasModule [
	"Return if there is a loadable and working Glutin library installed, false otherwise"
	<return: #Boolean>
	| aResult |

	aResult := nil.
	
	[ aResult := self primTest ]
		on: Error
		do: [ :e | aResult := false ].

	^ aResult ifNil: [ false ]
]

{ #category : #'accessing platform' }
GtClipboardLibrary >> macModuleName [
	^ self detectLibrary: 'libClipboard.dylib'
]

{ #category : #'private - ffi' }
GtClipboardLibrary >> primTest [
	^ self ffiCall: #(bool clipboard_test())
]

{ #category : #'accessing platform' }
GtClipboardLibrary >> unixModuleName [
	^ self detectLibrary: 'libClipboard.so'
]

{ #category : #'accessing platform' }
GtClipboardLibrary >> win32ModuleName [
	^ self detectLibrary: 'libClipboard.dll'
]
