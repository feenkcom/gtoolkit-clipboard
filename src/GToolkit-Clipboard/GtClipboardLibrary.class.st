Class {
	#name : #GtClipboardLibrary,
	#superclass : #FFILibrary,
	#traits : 'TGtWithStringBox + TGtWithPhlowRust',
	#classTraits : 'TGtWithStringBox classTrait + TGtWithPhlowRust classTrait',
	#category : #'GToolkit-Clipboard-Clipboard'
}

{ #category : #'library path' }
GtClipboardLibrary class >> ffiLibrary [
	^ self
]

{ #category : #'api - library' }
GtClipboardLibrary >> androidLibraryName [
	^ 'libClipboard.so'
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
	^ FFIMacLibraryFinder findLibrary: 'libClipboard.dylib'
]

{ #category : #'private - ffi' }
GtClipboardLibrary >> primTest [
	^ self ffiCall: #(bool clipboard_test())
]

{ #category : #'api - library' }
GtClipboardLibrary >> unix32LibraryName [
	^ FFIUnix32LibraryFinder findLibrary: 'libClipboard.so'
]

{ #category : #'api - library' }
GtClipboardLibrary >> unix64LibraryName [
	^ FFIUnix64LibraryFinder findLibrary: 'libClipboard.so'
]

{ #category : #'api - library' }
GtClipboardLibrary >> win32LibraryName [
	^ FFIWindowsLibraryFinder findLibrary: 'Clipboard.dll'
]
