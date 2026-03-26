Class {
	#name : #GtClipboardExamples,
	#superclass : #Object,
	#category : #'GToolkit-Clipboard-Examples'
}

{ #category : #examples }
GtClipboardExamples >> clipboardCanWorkWithText [
	<gtExample>
	<return: #GtClipboard>
	| clipboard text string |
	clipboard := GtClipboard new.
	string := 'Hello clipboard'.
	text := string asRopedText.
	
	clipboard clipboardText: text.
	
	self assert: clipboard clipboardText asString equals: string.
	self assert: clipboard recentClippings first asString equals: string.
	^ clipboard
]

{ #category : #examples }
GtClipboardExamples >> clipboardKeepsAtMostFiveRecentClippings [
	<gtExample>
	<return: #GtClipboard>
	| clipboard values |
	clipboard := GtClipboard new.
	values := #('one' 'two' 'three' 'four' 'five' 'six').
	
	values do: [ :each | clipboard clipboardText: each ].
	
	self assert: clipboard recentClippings size equals: 5.
	self assert: clipboard recentClippings first asString equals: 'six'.
	self assert: clipboard recentClippings last asString equals: 'two'.
	^ clipboard
]

{ #category : #examples }
GtClipboardExamples >> clipboardStoresAndReturnsString [
	<gtExample>
	<return: #GtClipboard>
	| clipboard string |
	clipboard := GtClipboard new.
	string := 'Hello clipboard'.
	
	clipboard clipboardText: string.
	
	self assert: clipboard clipboardText asString equals: string.
	self assert: clipboard recentClippings first asString equals: string.
	^ clipboard
]
