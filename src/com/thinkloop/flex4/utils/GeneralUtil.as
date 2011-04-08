package com.thinkloop.flex4.utils {

import mx.collections.Sort;

public class GeneralUtil{

	// make sort
	public static function makeSort(fields:Array):Sort {
		var sort:Sort = new Sort;
		sort.fields = fields;
		return sort;
	}
	
	// generate random int
	public static function generateRandomInt(from:int, to:int):int {
		return Math.floor(Math.random() * (1 + to - from)) + from;
	}	
	
	/* make timer
	public static function makeTimer(delay:Number, repeatCount:int, eventListener_TIMER:Function = null, eventListener_TIMER_COMPLETE:Function = null):Timer {
		var timer:Timer = new Timer(delay, repeatCount);
		
		if (eventListener_TIMER != null) {
			timer.addEventListener(TimerEvent.TIMER, eventListener_TIMER);
		}
		
		if (eventListener_TIMER_COMPLETE != null) {
			timer.addEventListener(TimerEvent.TIMER, eventListener_TIMER_COMPLETE);
		}		
		
		return timer;
	}
	*/	
}}