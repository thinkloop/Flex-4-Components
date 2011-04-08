package com.thinkloop.flex4.utils {

import flash.utils.getTimer;

public class TimerUtil {
	
	// constructor
	public function TimerUtil() {
		snapTime();
	}
	
	// properties
	public var snapshots:Array = [];
	
	// time
	public function time(text:String = '', ... args):void {
		snapTime();
		
		// if there is no text or args to display, take a silent time snapshot
		if (text == '' && args.length <= 0) {
			return;
		}
		
		// use provided text or default
		var finalText:String = text;
		
		// add args
		for each (var s:String in args) {
			finalText += ', ' + s;
		}
		
		// add timer
		if (snapshots.length >= 2) {
			var diff:Number = (snapshots[snapshots.length - 1] - snapshots[snapshots.length - 2]) / 1000;
			if (diff < 1000000) {
				finalText += ' [' + StringUtil.formatNumber(diff) + 's]';
			}
			else {
				finalText += ' [' + diff + 's]';
			}
				
		}
		else {
			finalText += ' [0ms]';
		}
		
		trace(finalText);
	}
	
	// snap time
	public function snapTime():void {
		snapshots.push(getTimer());
	}	
}}