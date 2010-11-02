package com.thinkloop.flex4.utils {

public class StringUtil{
	public function StringUtil() {
	}

	public static function trim(val:String):String {
		var finalString:String = val;
		var regex:RegExp = /^(\s*)([\W\w]*)(\b\s*$)/;
		
		finalString = finalString.replace(regex, '$2');
		
		return finalString;
	}
	
	public static function cleanExtraWhiteSpace(val:String):String {
		var finalString:String = val;
		var regex:RegExp = / +/g;
		
		finalString = finalString.replace(regex, ' ');
		finalString = trim(finalString);
		
		if (finalString == ' ') {
			finalString = '';
		}
		
		return finalString;
	}
	
	// strip html tags
	public static function StripHtmlTags(val:String):String {
		return val.replace(RegExp(/<.*?>/g), "");
	}
}}