package com.thinkloop.flex4.components.sparkTreeClasses {
	
    import mx.collections.ArrayList;

    /** 
     *  A class that takes XML and a list of open nodes and creates an IList
     */
    public class XMLLinearIList extends ArrayList
    {

        public var xml:XML;

        public var openNodes:Array;

        public var queryString:String;

        public function XMLLinearIList( xml:XML, openNodes:Array, queryString:String = "*" )
        {
            super();
            this.xml = xml;
            this.openNodes = openNodes;
            this.queryString = queryString;
            reset();
        }

        public function reset():void
        {
            var arr:Array = [];
            addChildren(xml, arr);
            source = arr;
        }

        protected function addChildren(xml:XML, arr:Array):void
        {
            var list:XMLList = xml[queryString];
            var n:int = list.length();
            for (var i:int = 0; i < n; i++)
            {
                arr.push(list[i]);
                if (isOpen(list[i]))
                    addChildren(list[i], arr);
            }
        }

        protected function isOpen(xml:XML):Boolean
        {
            return openNodes.indexOf(xml) != -1;
        }

        public function openNode(xml:XML):void
        {
            openNodes.push(xml);
            var arr:Array = [];
            addChildren(xml, arr);
            var i:int = getItemIndex(xml);
            while (arr.length)
            {
                addItemAt(arr.shift(), ++i);
            }
        }

        public function closeNode(xml:XML):void
        {
            var i:int = openNodes.indexOf(xml);
            if (i != -1)
            {
                openNodes.splice(i, 1);
                var arr:Array = [];
                addChildren(xml, arr);
                i = getItemIndex(xml) + 1;
                while (arr.length)
                {
                    removeItemAt(i);
                    arr.shift();
                }
            }
        }

        public function getDepth(xml:XML):int
        {
            var depth:int = 0;

            var parent:XML = xml.parent();
            while (parent)
            {
                depth++;
                parent = parent.parent();
            }
            return depth;
        }

    }
}