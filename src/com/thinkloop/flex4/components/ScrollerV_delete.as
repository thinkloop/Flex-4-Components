package com.thinkloop.flex4.components {
	
import mx.core.mx_internal;
use namespace mx_internal;

import spark.components.VScrollBar;

import flash.events.MouseEvent;
import com.thinkloop.flex4.components.skins.VScrollBarSkin;

public class ScrollerV_delete extends VScrollBar {
	
	public function ScrollerV_delete() {
		super();
		setStyle('skinClass', Class(VScrollBarSkin));
	}

	override protected function setValue(val:Number):void {
// trace('setValue: ' + val);		
		super.setValue(val);
	}

	override public function set maximum(val:Number):void {	
		super.maximum = val;
// trace('set maximum: ' + super.maximum + ' --- ' + maximum);	
	}
	
	override mx_internal function mouseWheelHandler(event:MouseEvent):void {
		var delta:Number = event.delta;
		var direction:Number = 0;
		var distance:Number = 30;
		
		// figure out the direction of scroll
		if (delta < 0){
			direction = 1;
		} else if (delta == 0){
			direction = 0;
		} else {
			direction = -1;
		}
		
		event.preventDefault();
	}	
}}