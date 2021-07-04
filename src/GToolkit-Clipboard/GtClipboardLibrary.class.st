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

{ #category : #'api - library' }
GtClipboardLibrary >> detectLibrary: aFileName [
	"Pharo9 introduced a platform specific FFILibraryFinder which should be used instead of this custom implementation"

	^ ({ Smalltalk imageDirectory . Smalltalk vmDirectory . Smalltalk vmBinary parent / 'Plugins'. FileSystem workingDirectory }
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

{ #category : #'api - library' }
GtClipboardLibrary >> macLibraryName [
	^ self class environment
		at: #FFIMacLibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libClipboard.dylib' ]
		ifAbsent: [ self detectLibrary: 'libClipboard.dylib' ]
]

{ #category : #'private - ffi' }
GtClipboardLibrary >> primTest [
	^ self ffiCall: #(bool clipboard_test())
]

{ #category : #'api - library' }
GtClipboardLibrary >> unix32LibraryName [
	^ self class environment
		at: #FFIUnix32LibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libClipboard.so' ]
		ifAbsent: [ self detectLibrary: 'libClipboard.so' ]
]

{ #category : #'api - library' }
GtClipboardLibrary >> unix64LibraryName [
	^ self class environment
		at: #FFIUnix64LibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libClipboard.so' ]
		ifAbsent: [ self detectLibrary: 'libClipboard.so' ]
]

{ #category : #'api - library' }
GtClipboardLibrary >> win32LibraryName [
	^ self class environment
		at: #FFIWindowsLibraryFinder
		ifPresent: [ :aLibraryFinder | aLibraryFinder findLibrary: 'libClipboard.dll' ]
		ifAbsent: [ self detectLibrary: 'libClipboard.dll' ]
]
