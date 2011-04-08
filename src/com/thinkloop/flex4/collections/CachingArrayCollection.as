package com.thinkloop.flex4.collections {
	
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

public class CachingArrayCollection extends ArrayCollection implements ICollectionView {

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTANTS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	

	public static const DEFAULT_CACHE_PROPERTY:String = 'id';
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTRUCTOR
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
		
	public function CachingArrayCollection(source:Array = null, cachePropertyNames:Array = null) {
		super(source);
		
		// cache property names
		this.cachePropertyNames = cachePropertyNames ? cachePropertyNames : [];
		
		// init cache
		cacheRebuild();
	}

	// cache init
	protected function cacheInit():void {
		
		// cache dictionary
		cacheDictionary = new Dictionary(true);
		
		// create a sub-dictionary for each property in main dictionary
		for each (var s:String in cachePropertyNames) {
			cacheDictionary[s] = new Dictionary(true);
		}
	}
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * PROPERTIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
		
	protected var cachePropertyNames:Array;
	protected var cacheDictionary:Dictionary;

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * PUBLIC METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// get object(s) from the cache based on a value of one of its cached properties (i.e. its id). If no property names are specified, all cached properties are searched)
	public function cacheGet(propertyValue:Object, propertyNames:Array = null):Array {
		var results:Array = [];
		
		if (propertyNames == null || propertyNames.length == 0) {
			propertyNames = cachePropertyNames;
		}
		
		for each (var s:String in propertyNames) {
			if (cacheDictionary[s] && cacheDictionary[s][propertyValue]) {
				results = results.concat(cacheDictionary[s][propertyValue]);
			}
		}
		
		return results;
	}
	
	// cache list keys
	public function cacheListKeys(propertyName:String = DEFAULT_CACHE_PROPERTY):Array {
		var results:Array = [];
		
		var currentDictionary:Dictionary = cacheDictionary[propertyName];
		
		for (var key:Object in currentDictionary) {
			results.push(key);
		}	
		
		return results;
	}
	
	// cache list values
	public function cacheListValues(propertyName:String = DEFAULT_CACHE_PROPERTY):Array {
		var results:Array = [];
		
		var currentDictionary:Dictionary = cacheDictionary[propertyName];
		
		for each (var a:Array in currentDictionary) {
			results = results.concat(a);
		}
		
		return results;
	}	
	
	// cache sum
	public function cacheSum(propertyName:String = DEFAULT_CACHE_PROPERTY):Number {
		var sum:Number = 0;
		
		var currentDictionary:Dictionary = cacheDictionary[propertyName];
		
		for (var key:Object in currentDictionary) {
			var hitCount:Number = Number(key);
			sum += hitCount * currentDictionary[key].length;
		}
		
		return sum;
	}
	
	// cache rebuild
	public function cacheRebuild():Dictionary {
		cacheInit();
		for each (var o:Object in source) {
			cacheAdd(o);
		}
		
		return cacheDictionary;
	}
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * PRTOECTED METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// add an item to the cache
	protected function cacheAdd(item:Object):void {
		for each (var s:String in cachePropertyNames) {
			var itemPropertyValue:Object = getItemPropertyValue(s, item);
			if (itemPropertyValue) {
				if (cacheDictionary[s][itemPropertyValue]) {
					cacheDictionary[s][itemPropertyValue].push(item);
				}
				else {
					cacheDictionary[s][itemPropertyValue] = [item];
				}
			}
		}
	}
	
	// remove an item from the cache
	protected function cacheRemove(item:Object):void {
		for each (var s:String in cachePropertyNames) {
			var itemPropertyValue:Object = getItemPropertyValue(s, item);
			if (itemPropertyValue) {
				if (cacheDictionary[s][itemPropertyValue]) {
					var newArray:Array = [];
					for each (var o:Object in cacheDictionary[s][itemPropertyValue] as Array) {
						if (o != item) {
							newArray.push(o);
						}
					}
					if (newArray.length > 0) {
						cacheDictionary[s][itemPropertyValue] = newArray;
					}
					else {
						delete cacheDictionary[s][itemPropertyValue];
					}
				}
			}
		}
	}	
	
	// get item property value: if the item refers to nested properties (using periods), it will recurse through the children and find the right property
	protected function getItemPropertyValue(propertyName:String, item:Object):Object {
		var chain:Array = propertyName.split('.');
		
		if (chain.length <= 0) {
			return null;
		}
		
		var finalValue:Object = item;
		
		for each (var s:String in chain) {
			if (finalValue && s in finalValue) {
				finalValue = finalValue[s];
			}
			else {
				return null;
			}
		}
		
		return finalValue;
	}
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * OVERRIDES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// add item at
	override public function addItemAt(item:Object, index:int):void {
		cacheAdd(item);
		super.addItemAt(item, index);
	}
	
	// remove item at
	override public function removeItemAt(index:int):Object {
		var superResult:Object = super.removeItemAt(index);
		
		cacheRemove(superResult);
		
		return superResult;
	}

	// remove all
	override public function removeAll():void {
		cacheInit();
		super.removeAll();
	}	
	
	// remove all
	override public function set source(s:Array):void {
		super.source = s;
		cacheRebuild();
	}		
}}