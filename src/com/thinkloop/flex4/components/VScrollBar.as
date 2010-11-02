package com.thinkloop.flex4.components {
	
import mx.core.mx_internal;
use namespace mx_internal;

import spark.components.VScrollBar;

import flash.events.MouseEvent;
import com.thinkloop.flex4.components.skins.VScrollBarSkin;
import spark.core.IViewport;
import spark.core.NavigationUnit;
import mx.core.IInvalidating;

public class VScrollBar extends spark.components.VScrollBar {
	
	public function VScrollBar() {
		super();
	}

	override protected function setValue(val:Number):void {
// trace('setValue: ' + val);		
		super.setValue(val);
	}

	override public function set maximum(val:Number):void {	
		super.maximum = val;
// trace('set maximum: ' + super.maximum + ' --- ' + maximum);	
	}
	
	override mx_internal function mouseWheelHandler(event:MouseEvent):void
		{
			const vp:IViewport = viewport;
			if (event.isDefaultPrevented() || !vp || !vp.visible)
				return;
			
			var nSteps:uint = Math.max(Math.abs(maximum * 0.015), 50);
			var navigationUnit:uint;
			
			// Scroll event.delta "steps".  
			
			navigationUnit = (event.delta < 0) ? NavigationUnit.DOWN : NavigationUnit.UP;
			for (var vStep:int = 0; vStep < nSteps; vStep++)
			{
				var vspDelta:Number = vp.getVerticalScrollPositionDelta(navigationUnit);
				if (!isNaN(vspDelta))
				{
					vp.verticalScrollPosition += vspDelta;
					if (vp is IInvalidating)
						IInvalidating(vp).validateNow();
				}
			}
			
			event.preventDefault();
		}	
}}