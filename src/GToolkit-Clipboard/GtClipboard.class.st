Class {
	#name : #GtClipboard,
	#superclass : #Clipboard,
	#instVars : [
		'context',
		'session',
		'mutex'
	],
	#category : #'GToolkit-Clipboard'
}

{ #category : #'library path' }
GtClipboard class >> ffiLibraryName [
	^ GtClipboardLibrary
]

{ #category : #initialization }
GtClipboard class >> initialize [
	self startUp: true.

	SessionManager default registerUserClassNamed: self name
]

{ #category : #initialization }
GtClipboard class >> shutDown: isImageQuitting [
	"Pharo is shutting down. If this platform requires specific shutdown code, this is a great place to put it."

]

{ #category : #initialization }
GtClipboard class >> startUp: isImageStarting [
	"Pharo is starting up. If this platform requires specific intialization, this is a great place to put it."
	isImageStarting
		ifTrue: [ Default := self new ]
]

{ #category : #initialization }
GtClipboard >> beDefault [
	Default := self
]

{ #category : #accessing }
GtClipboard >> clipboardText [
	"Return the text currently in the clipboard. If the system clipboard is empty, or if it differs from the Smalltalk clipboard text, use the Smalltalk clipboard. This is done since (a) the Mac clipboard gives up on very large chunks of text and (b) since not all platforms support the notion of a clipboard."
	| string |
	string := self primitiveClipboardText.
	(string isEmpty or: [ string = contents asString ])
		ifTrue: [ ^ contents ].

	^ string = contents asString
		ifTrue: [ contents ]
		ifFalse: [ string asText ]
]

{ #category : #accessing }
GtClipboard >> clipboardText: text [ 
	| string |
  
	string := text asString.
   self noteRecentClipping: text asText copyWithoutExternalReferences.
   contents := text asText copyWithoutExternalReferences.
   self primitiveClipboardText: string
]

{ #category : #initialization }
GtClipboard >> ensureContext [
	<return: #Boolean>
	(session == Smalltalk session
		and: [ context isNotNil
			and: [ context isValid ] ])
		ifTrue: [ ^ true ].
	
	GtClipboardLibrary uniqueInstance hasModule
		ifFalse: [ ^ false ].

	session := Smalltalk session.
	context := GtClipboardContext new.

	^ context isValid
]

{ #category : #'library path' }
GtClipboard >> ffiLibraryName [
	^ self class ffiLibraryName
]

{ #category : #initialization }
GtClipboard >> initialize [
	super initialize.

	mutex := Mutex new
]

{ #category : #primitives }
GtClipboard >> primitiveClipboardText [
	"Get the current clipboard text. Return the empty string if the primitive fails."
	| aString |

	aString := ''.
	mutex critical: [
		self ensureContext
			ifTrue: [ aString := context getContents ] ].
	^ aString
]

{ #category : #primitives }
GtClipboard >> primitiveClipboardText: aString [
	"Set the current clipboard text to the given string."

	mutex critical: [
		self ensureContext
			ifTrue: [ context setContents: aString ] ]
]
