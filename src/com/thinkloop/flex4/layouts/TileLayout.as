package com.thinkloop.flex4.layouts {
import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.layouts.TileLayout;

public class TileLayout extends spark.layouts.TileLayout {

	
	override public function updateDisplayList(width:Number, height:Number) : void	{
		super.updateDisplayList(width, height);
		var layoutTarget:GroupBase = target;
		layoutTarget.explicitHeight = Math.ceil(rowCount * (rowHeight + verticalGap) - verticalGap);	
	}	
	
}}