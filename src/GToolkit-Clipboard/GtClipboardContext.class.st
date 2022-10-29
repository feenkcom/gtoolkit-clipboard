Class {
	#name : #GtClipboardContext,
	#superclass : #GtBoxerValueBox,
	#category : #'GToolkit-Clipboard'
}

{ #category : #'library path' }
GtClipboardContext class >> ffiLibrary [
	^ GtClipboardLibrary
]

{ #category : #'private - ffi' }
GtClipboardContext class >> primCreate [
	^ self ffiCall: #(void* clipboard_create_clipboard_context())
]

{ #category : #'private - ffi' }
GtClipboardContext class >> primRelease: aHandle [
	
	"Plain pointers must be deleted using delete(), all users must implement a specific method"
	^ self ffiCall: #(void clipboard_destroy_clipboard_context(void* aHandle))
]

{ #category : #accessing }
GtClipboardContext >> getContents [
	<return: #String>

	^ GtBoxerString getStringFrom: [ :aBoxerString | self primGetContents: aBoxerString ]
]

{ #category : #'private - ffi' }
GtClipboardContext >> primGetContents: aGtBoxerString [
	^ self ffiCall: #(void clipboard_get_contents(GtClipboardContext self, GtBoxerString aGtBoxerString))
]

{ #category : #'private - ffi' }
GtClipboardContext >> primSetContents: aGtBoxerString [
	^ self ffiCall: #(void clipboard_set_contents(GtClipboardContext self, GtBoxerString aGtBoxerString))
]

{ #category : #accessing }
GtClipboardContext >> setContents: aString [
	GtBoxerString
		fromString: aString
		during: [ :aBoxerString | self primSetContents: aBoxerString ]
]
