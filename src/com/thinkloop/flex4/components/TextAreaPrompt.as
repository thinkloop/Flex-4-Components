package com.thinkloop.flex4.components {

import flash.events.FocusEvent;

import spark.components.TextArea;

//--------------------------------------------------------------------------
//
//  Events
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Skin States
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
//  Styles
//
//--------------------------------------------------------------------------

public class TextAreaPrompt extends TextArea {
	
//--------------------------------------------------------------------------
//
//  Skin Parts
//
//--------------------------------------------------------------------------
	
//--------------------------------------------------------------------------
//
//  Constants
//
//--------------------------------------------------------------------------
	
//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------
	
	public function TextAreaPrompt() {
		super();
	}
	
//--------------------------------------------------------------------------
//
//  Properties
//
//--------------------------------------------------------------------------	
	
	public var promptText:String = '';
	
	// is focused
	protected var _isFocused:Boolean;
	protected var _isFocusedDirty:Boolean;
	[Bindable]
	public function set isFocused(value:Boolean):void {
		_isFocused = value;
		_isFocusedDirty = true;
		invalidateProperties();
	}
	public function get isFocused():Boolean	{
		return _isFocused;
	}

	
//--------------------------------------------------------------------------
//
//  Overrides
//
//--------------------------------------------------------------------------	

	override protected function partAdded(partName:String, instance:Object):void {
		super.partAdded(partName, instance);
		
		if (instance == textDisplay) {
			textDisplay.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			textDisplay.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			_isFocusedDirty = true;
			invalidateProperties();
		}
	}
	
	override protected function partRemoved(partName:String, instance:Object):void {
		super.partRemoved(partName, instance);
		
		if (instance == textDisplay) {
			textDisplay.removeEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			textDisplay.removeEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
		}
	}
	
	override protected function commitProperties():void {
		super.commitProperties();
		
		if (_isFocusedDirty) {
			_isFocusedDirty = false;
			
			if (isFocused) {
				if (text == promptText) {
					textDisplay.text = '';
					textDisplay.setStyle('color', getStyle('color'));
				}				
			}
			else {
				if (text == '') {
					textDisplay.text = promptText;
					textDisplay.setStyle('color', getStyle('disabledColor'));
				}				
			}
		}
	}
	
//--------------------------------------------------------------------------
//
//  Handlers
//
//--------------------------------------------------------------------------	
	
	private function handleFocusIn(event:FocusEvent = null):void {
		isFocused = true;
	}
	
	private function handleFocusOut(event:FocusEvent):void {
		isFocused = false;
	}	
}}