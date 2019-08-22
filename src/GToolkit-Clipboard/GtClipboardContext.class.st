Class {
	#name : #GtClipboardContext,
	#superclass : #FFIExternalObject,
	#category : #'GToolkit-Clipboard'
}

{ #category : #'library path' }
GtClipboardContext class >> ffiLibraryName [
	^ GtClipboardLibrary
]

{ #category : #finalization }
GtClipboardContext class >> finalizeResourceData: aHandle [
	
	self release: aHandle
]

{ #category : #'instance creation' }
GtClipboardContext class >> new [
	^ self primCreate autoRelease
]

{ #category : #'private - ffi' }
GtClipboardContext class >> primCreate [
	^ self ffiCall: #(GtClipboardContext clipboard_create_clipboard_context())
]

{ #category : #'private - ffi' }
GtClipboardContext class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void clipboard_destroy_clipboard_context(void* aHandle))
]

{ #category : #finalization }
GtClipboardContext class >> release: aHandle [

	aHandle isNull
		"A handle may already be null, if garbage collector did his job before us :) "
		ifTrue: [ ^ self ].

	self warning: [ '(release) Ptr: ', aHandle value asString ].
	self primRelease: aHandle.
	aHandle getHandle beNull
]

{ #category : #finalization }
GtClipboardContext class >> warning: aMessageBlock [ 
	"| message |

	message := '[', self name asString ,'] ', aMessageBlock value.

	Transcript show: message; cr"
]

{ #category : #'library path' }
GtClipboardContext >> ffiLibraryName [
	^ self class ffiLibraryName
]

{ #category : #accessing }
GtClipboardContext >> getContents [
	| aBuffer aString |

	aBuffer := self primGetContents.
	aString := aBuffer readStringUTF8.

	self primFreeContents: aBuffer getHandle.
	aBuffer beNull.

	^ aString
]

{ #category : #testing }
GtClipboardContext >> isValid [
	^ handle isNotNil and: [ handle isNull not ]
]

{ #category : #'private - ffi' }
GtClipboardContext >> primFreeContents: aHandle [
	^ self ffiCall: #(void clipboard_free_contents(void* aHandle))
]

{ #category : #'private - ffi' }
GtClipboardContext >> primGetContents [
	^ self ffiCall: #(void* clipboard_get_contents(GtClipboardContext self))
]

{ #category : #'private - ffi' }
GtClipboardContext >> primSetContents: aString [
	^ self ffiCall: #(void clipboard_set_contents(GtClipboardContext self, ByteArray aString))
]

{ #category : #'private - ffi' }
GtClipboardContext >> release [

	self class release: self resourceData.
	
	"#release is sent manually, so we want to make sure that resource is no longer
	added to weak registry - performance improvement"
	(FFIExternalResourceManager uniqueInstance instVarNamed: #registry) remove: self ifAbsent: [ ]
]

{ #category : #accessing }
GtClipboardContext >> setContents: aString [
	| encodedString |
	
	encodedString := ByteArray streamContents: [ :aStream |
		ZnUTF8Encoder new 
			next: aString size 
			putAll: aString asString
			startingAt: 1 
			toStream: aStream.
		aStream nextPut: 0 ].
	
	self primSetContents: encodedString
]
