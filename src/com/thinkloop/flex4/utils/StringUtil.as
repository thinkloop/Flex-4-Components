package com.thinkloop.flex4.utils {
	import mx.formatters.DateFormatter;
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;

public class StringUtil{

	public static function repeat(str:String, n:int):String {
		var finalString:String = '';
		while (n > 0) {
			finalString += str;
			n--;
		}
		return finalString;
	}
	
	public static function trim(str:String):String {
		var finalString:String = str;
		var regex:RegExp = /^(\s*)([\W\w]*)(\b\s*$)/;
		
		finalString = finalString.replace(regex, '$2');
		
		return finalString;
	}
	
	public static function cleanAllWhiteSpace(str:String):String {
		if (str == null || str.length <= 0) {
			return '';
		}
		
		var finalString:String = str;
		var regex:RegExp = / +/sg;
		
		finalString = finalString.replace(regex, ' ');
		finalString = trim(finalString);
		
		if (finalString == ' ') {
			finalString = '';
		}
		
		return finalString;
	}
	
	// strip html tags
	public static function stripHtmlTags(str:String):String {
		return str.replace(RegExp(/<.*?>/g), "");
	}
	
	// match all terms: returns an array of objects that include the substring that matched, and the start index position, and end index position, of where they matched.
	public static function matchAllTerms(str:String, terms:Array):Array {
		var finalArray:Array = [];		
		var joinedTerms:String = terms.join('|');
		
		// it is better to check "joinedTerms" here rather than just "terms" earlier on because it is possible that "terms" has items that are empty strings, thereby passing the test ontop but causing an error. This way, we are sure that no empty strings slip through.
		if (joinedTerms.length <= 0) {
			return finalArray; 
		}
		
		var regex:RegExp = new RegExp('(\\b)(' + joinedTerms + ')(\\b)', 'ig');
		var regexResult:Object = regex.exec(str);
		
		while (regexResult != null) {
			finalArray.push( { substring:regexResult[0].toString(), startIndex:regexResult['index'], endIndex:regexResult['index'] + regexResult[0].toString().length } );
			regexResult = regex.exec(str);
		}
		
		return finalArray;
	}
	
	/* match between markers: returns an array of objects that include the substring in between the provided markers, and the start index position, and end index position, of where they matched. This is typically used for search results with highlighted terms like "One <em>word</em> in this sentence is between markers."
	public static functiostratchBetweenMarkers(str:String, startMarker:String, endMarker:String):Array {
		var finalArray:Array = [];
		
		var regex:RegExp = new RegExp(startMarker, 'g');
		var regexResult:Object = regex.exec(str);
		
		while (regexResult != null) {
			finalArray.push( { substring:regexResult[0].toString(), startIndex:regexResult['index'], endIndex:regexResult['index'] + regexResult[0].toString().length } );
			regexResult = regex.exec(str);
		}
		
		return finalArray;
	}	
	*/
	
	// format number - the 'width' param pads the number with leading zeros until the width is reached
	public static function formatNumber(num:Number, decimalPlaces:int = 0, width:int = 0):String {
		var formatter:NumberFormatter = new NumberFormatter();
		formatter.precision = decimalPlaces;
		formatter.rounding = NumberBaseRoundType.NEAREST;
		formatter.useThousandsSeparator = true;
		formatter.useNegativeSign = true;
		
		var finalFormat:String = formatter.format(num);
		while(finalFormat.length < width) {
			finalFormat = '0' + finalFormat;
		}
		
		return finalFormat;
	}
	
	// remove leading chars
	public static function removeLeadingChars(str:String, chars:String):String {
		while (str.substr(0, chars.length) == chars) {
			if (str.length >= chars.length + 1) {
				str = str.substring(chars.length);
			}
			else {
				str = '';
			}
		}
		
		return str;
	}
	
	// format date
	public static function formatDate(date:Date, format:String = 'MM/DD/YYYY'):String {
		var df:DateFormatter = new DateFormatter();
		df.formatString = format;
		
		return df.format(date);
	}
	
	// format date w3c
	public static function formatDateW3C(d:Date):String {
		var year:int = d.getFullYear();
		var month:Number = d.month;
		var date:Number = d.date;
		var hours:Number = d.hours;
		var minutes:Number = d.minutes;
		var seconds:Number = d.seconds;
		var milliseconds:Number = d.milliseconds;
		
		var w3cDate:String = '';
		
		w3cDate += year;
		w3cDate += "-";
		
		if (month + 1 < 10)
		{
			w3cDate += "0";
		}
		w3cDate += month + 1;
		w3cDate += "-";
		if (date < 10)
		{
			w3cDate += "0";
		}
		w3cDate += date;
		w3cDate += "T";
		if (hours < 10)
		{
			w3cDate += "0";
		}
		w3cDate += hours;
		w3cDate += ":";
		if (minutes < 10)
		{
			w3cDate += "0";
		}
		w3cDate += minutes;
		w3cDate += ":";
		if (seconds < 10)
		{
			w3cDate += "0";
		}
		w3cDate += seconds;
	
		w3cDate += ".";
		w3cDate += milliseconds;
		
		w3cDate += "-00:00Z";
		
		return w3cDate;
	}	
	
	// parse date w3c
	public static function parseDateW3C(w3cDate:String):Date {
		return new Date(w3cDate.substr(0, 4), int(w3cDate.substr(5, 2)) - 1, w3cDate.substr(8, 2), w3cDate.substr(11, 2), w3cDate.substr(14, 2), w3cDate.substr(17, 2), w3cDate.substr(20, 3));
	}	
}}