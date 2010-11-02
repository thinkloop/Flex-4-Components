package com.thinkloop.flex4.collections {
	
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

public class CachingArrayCollection extends ArrayCollection implements ICollectionView {
		
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTRUCTOR
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
		
	public function CachingArrayCollection(source:Array = null) {
		super(source);
	}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * PROPERTIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
		
	public var idPropertyName:String = 'id';
	private var _itemsCache:Object = {};
	private var resourceManager:IResourceManager = ResourceManager.getInstance();

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// add item at
	override public function addItemAt(item:Object, index:int):void {
		if (index < 0 || !list || index > length) {
			var message:String = resourceManager.getString("collections", "outOfBounds", [index]);
			throw new RangeError(message);
		}
		var listIndex:int = index;

		//if we're sorted addItemAt is meaningless, just add to the end
		if (localIndex && sort) {
			listIndex = list.length;
		}
		else if (localIndex && filterFunction != null) {
			// if end of filtered list, put at end of source list
			if (listIndex == localIndex.length) {
				listIndex = list.length;
			}
			// if somewhere in filtered list, find it and insert before it
			// or at beginning
			else {
				listIndex = list.getItemIndex(localIndex[index]);
			}
		}
		list.addItemAt(item, listIndex);
		
		// ** THINKLOOP **
//trace(item[idPropertyName] + ' = ' + listIndex);		
		_itemsCache['id' + item[idPropertyName]] = listIndex;
	}
	
	// remove item at
	override public function removeItemAt(index:int):Object {
		if (index < 0 || index >= length) {
			var message:String = resourceManager.getString(
				"collections", "outOfBounds", [ index ]);
			throw new RangeError(message);
		}
		
		var listIndex:int = index;
		if (localIndex) {
			var oldItem:Object = localIndex[index];
			listIndex = list.getItemIndex(oldItem);
		}
		
		// ** THINKLOOP (only one line) **
		delete _itemsCache['id' + list[listIndex][idPropertyName]];

		return list.removeItemAt(listIndex);
	}
	
	// remove all
	override public function removeAll():void {
		_itemsCache = new Object();
		super.removeAll();
	}
	
	public function getItemByID(id:String):Object {
		var index:int = getIndexByID(id);

		if (index >= 0 && index < this.length) {
			return getItemAt(index);	
		}
		else {
			return null;
		}
	}
	
	public function getIndexByID(id:String):int {
		var b:Boolean = _itemsCache.hasOwnProperty('id' + id);
		
		if (_itemsCache.hasOwnProperty('id' + id)) {
			return _itemsCache['id' + id];	
		}
		else {
			return -1;	
		}
	}	
}}