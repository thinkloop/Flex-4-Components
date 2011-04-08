package com.thinkloop.flex4.components {

import com.thinkloop.flex4.components.skins.SearchBoxSkin;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

import spark.components.Button;
import spark.components.Label;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableComponent;
import spark.events.TextOperationEvent;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * EVENTS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

[Event(name="submit", type="flash.events.Event")] // (important event) this event will fire if either the submit button is clicked OR the enter key is pressed. Other logic that determines a 'sbumit' action may be added in the future.

[Event(name="textChanged", type="flash.events.Event")]
[Event(name="enterKeyPressed", type="flash.events.Event")]
[Event(name="submitButtonClicked", type="flash.events.Event")]
[Event(name="clearButtonClicked", type="flash.events.Event")]

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * SKIN STATES
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

[SkinState("active")]
[SkinState("searching")]
[SkinState("disabled")]

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * OTHER METADATA
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

[DefaultProperty("label")]

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * SEARCH BOX
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

public class SearchBox extends SkinnableComponent {

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * SKIN PARTS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
	
	[SkinPart(required="true")] public var searchButton:SearchBoxButton;
	[SkinPart(required="true")] public var textInput:TextInput;
	[SkinPart(required="true")] public var clearButton:Button;
	
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * CONSTANTS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
	
	public static const TEXT_CHANGED:String = 'textChanged';
	public static const ENTER_KEY_PRESSED:String = 'enterKeyPressed';
	public static const SUBMIT_BUTTON_CLICKED:String = 'submitButtonClicked';
	public static const CLEAR_BUTTON_CLICKED:String = 'clearButtonClicked';
	public static const SUBMIT:String = 'submit';
	
	public static const NORMAL_STATE:String = '';
	public static const ACTIVE_STATE:String = 'active';
	public static const SEARCHING_STATE:String = 'searching';
	public static const DISABLED_STATE:String = 'disabled';
	
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * CONSTRUCTOR / INIT
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
	
	public function SearchBox() {
		super();
		
		// set skin classes
		setStyle("skinClass", SearchBoxSkin);
		addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
	}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * PROPERTIES
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
	
	// text
	protected var _text:String = '';
	protected var _textDirty:Boolean = false;
	[Bindable]
	public function set text(value:String):void {
		_text = value;
		_textDirty = true;

		if (value.length > 0) {
			isTextTyped = true;
		}
		else {
			isTextTyped = false;
		}
		
		dispatchEvent(new Event(TEXT_CHANGED));
		invalidateProperties();
	}
	public function get text():String {
		return _text;
	}
	
	// submit button label
	protected var _searchButtonLabel:String = 'search';
	protected var _searchButtonLabelDirty:Boolean = false;
	public function set searchButtonLabel(value:String):void {
		_searchButtonLabel = value;
		_searchButtonLabelDirty = true;
		invalidateProperties();
	}
	public function get searchButtonLabel():String {
		return _searchButtonLabel;
	}
	
	// is rolled over
	protected var _isRolledOver:Boolean = false;
	[Bindable]
	public function set isRolledOver(value:Boolean):void {
		_isRolledOver = value;
		invalidateSkinState();
	}
	public function get isRolledOver():Boolean {
		return _isRolledOver;
	}
	
	// is focused in
	protected var _isFocusedIn:Boolean = false;
	[Bindable]
	public function set isFocusedIn(value:Boolean):void {
		_isFocusedIn = value;
		invalidateSkinState();
	}
	public function get isFocusedIn():Boolean {
		return _isFocusedIn;
	}	

	// is text typed
	protected var _isTextTyped:Boolean = false;
	[Bindable]
	public function set isTextTyped(value:Boolean):void {
		_isTextTyped = value;
		invalidateSkinState();
	}
	public function get isTextTyped():Boolean {
		return _isTextTyped;
	}
	
	// is searching
	protected var _isSearching:Boolean = false;
	[Bindable]
	public function set isSearching(value:Boolean):void {
		_isSearching = value;
		searchButtonLabel = value ? 'searching' : 'search';
		invalidateSkinState();
	}
	public function get isSearching():Boolean {
		return _isSearching;
	}
	
	// is active
	protected var _isActive:Boolean = false;
	[Bindable]
	public function set isActive(value:Boolean):void {
		_isActive = value;
		invalidateSkinState();
	}
	public function get isActive():Boolean {
		return _isActive;
	}
	
	// is disabled
	[Bindable]
	override public function set enabled(value:Boolean):void {
		super.enabled = value;
		
		// enable or disable sub-components
		if (searchButton) { 
			searchButton.enabled = value; 
		}
		if (textInput) { 
			textInput.enabled = value; 
		}
		if (clearButton) { 
			clearButton.enabled = value; 
		}
		
		invalidateSkinState();
	}	

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * OVERRIDE
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
	
	// get current skin state
	override protected function getCurrentSkinState():String {
		var returnState:String = NORMAL_STATE;
		
		if (!enabled) {
			returnState = DISABLED_STATE;		
		}
			
		else if (isSearching) {
			returnState = SEARCHING_STATE;
		}
			
		else if (isRolledOver || isFocusedIn || isTextTyped || isActive) {
			returnState = ACTIVE_STATE;		
		}
	
		return returnState;
	}
	
	// commit properties
	override protected function commitProperties():void { 
		super.commitProperties(); 
		
		if (_textDirty) {
			_textDirty = false; 
			textInput.text = _text;
		}
		
		if (_searchButtonLabelDirty) {
			_searchButtonLabelDirty = false; 
			searchButton.label = _searchButtonLabel;
		}

		if (isRolledOver || isActive || isSearching || isFocusedIn || isTextTyped) {
			textInput.setStyle('color', getStyle('color'));
			
			if(!isTextTyped) {
				textInput.text = '';
			}
		}
		else {
			textInput.setStyle('color', '#cfcfcf');
			textInput.text = 'type search terms';
		}
	}
	
	// part added: initialize each sub-component, add event listeners, more...
	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
		
		switch(instance) {
			case textInput:
				textInput.editable = true;
				
				textInput.addEventListener(TextOperationEvent.CHANGE, textInput_changeHandler);
				textInput.addEventListener(FlexEvent.ENTER, textInput_enterHandler);
				textInput.addEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
				textInput.addEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
				break;
			
			case searchButton:
				searchButton.addEventListener(MouseEvent.CLICK, searchButton_clickHandler);
				searchButton.label = _searchButtonLabel;
				break;	
			
			case clearButton:
				clearButton.addEventListener(MouseEvent.CLICK, clearButton_clickHandler);
				break;
		}
	}
	
	// part removed: remove event listeners that were added in partAdded()
	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);
		
		switch(instance) {
			case textInput:
				textInput.removeEventListener(TextOperationEvent.CHANGE, textInput_changeHandler);
				textInput.removeEventListener(FlexEvent.ENTER, textInput_enterHandler);
				textInput.removeEventListener(FocusEvent.FOCUS_IN, textInput_focusInHandler);
				textInput.removeEventListener(FocusEvent.FOCUS_OUT, textInput_focusOutHandler);
				break;
				
			case searchButton:
				searchButton.removeEventListener(MouseEvent.CLICK, searchButton_clickHandler);
				break;
			
			case clearButton:
				clearButton.removeEventListener(MouseEvent.CLICK, clearButton_clickHandler);
				break;
		}
	}
	
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * HANDLERS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
	
	// handle search button click
	protected function searchButton_clickHandler(e:MouseEvent):void { 
//trace('search button clicked');
		dispatchEvent(new Event(SUBMIT_BUTTON_CLICKED));
		dispatchEvent(new Event(SUBMIT));
	}

	// handle clear button click
	protected function clearButton_clickHandler(e:MouseEvent):void { 
//trace('clear button clicked');
		text = '';
		textInput.setFocus();
	}
	
	// handle text change
	protected function textInput_changeHandler(e:TextOperationEvent):void {
		text = textInput.text;
	} 
	
	// handle pressing enter
	protected function textInput_enterHandler(e:FlexEvent):void { 
//trace('pressed enter');
		dispatchEvent(new Event(ENTER_KEY_PRESSED));
		dispatchEvent(new Event(SUBMIT));
	} 	
	
	// handle focus in
	protected function textInput_focusInHandler(e:FocusEvent):void {
		isFocusedIn = true;
	}
	
	// handle focus out
	protected function textInput_focusOutHandler(e:FocusEvent):void {
		isFocusedIn = false;
	}
	
	// handle roll over
	protected function rollOverHandler(e:MouseEvent):void {
		isRolledOver = true;
	}
	
	// handle roll out
	protected function rollOutHandler(e:MouseEvent):void {
		isRolledOver = false;
	}
}}