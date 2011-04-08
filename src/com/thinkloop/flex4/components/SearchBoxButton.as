package com.thinkloop.flex4.components {
import spark.components.Button;

/*
[Style(name="upColor",type="Number",format="Color",inherit="yes")]
[Style(name="upBGColor",type="Number",format="Color",inherit="yes")]
[Style(name="upBorderColor",type="Number",format="Color",inherit="yes")]

[Style(name="overColor",type="Number",format="Color",inherit="yes")]
[Style(name="overBGColor",type="Number",format="Color",inherit="yes")]
[Style(name="overBorderColor",type="Number",format="Color",inherit="yes")]

[Style(name="downColor",type="Number",format="Color",inherit="yes")]
[Style(name="downBGColor",type="Number",format="Color",inherit="yes")]
[Style(name="downBorderColor",type="Number",format="Color",inherit="yes")]
*/

public class SearchBoxButton extends Button {
	
	public var searchBoxSkinState:String = 'up';
	
	public function SearchBoxButton() {
		super();
	}
	
	// override get current skin state
	override protected function getCurrentSkinState():String {
		var superSkinState:String = super.getCurrentSkinState();

		if (superSkinState == 'disabled') {
			return 'disabled';
		}
		
		else if (superSkinState == 'down' || superSkinState == 'over') {
			return 'down';
		}
		
		else  if (searchBoxSkinState == 'searching') {
			return 'down';
		}
		
		else  if (searchBoxSkinState == 'active') {
			return 'over';
		}		
		
		else {
			return 'up';
		}
	}
}}