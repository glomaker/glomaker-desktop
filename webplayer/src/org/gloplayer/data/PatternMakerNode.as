package org.gloplayer.data
{
	import flash.geom.Point;
	import org.glomaker.shared.patternmaker.IPatternNode;

	public class PatternMakerNode implements IPatternNode
	{
	
		/**
		 * Original untyped node object instance. 
		 */
		protected var o:Object;
		
		/**
		 * Constructor 
		 * @param untypedNode
		 */
		public function PatternMakerNode(untypedNode:Object = null)
		{
			if(!untypedNode)
				untypedNode = {};

			o = untypedNode;
		}
		
		// ----------------------------------------------------
		// IPatternNode Implementation - GETTERS
		// ----------------------------------------------------

		public function get loc():Point { return o.loc; }
		public function get rootNode():Boolean { return o.rootNode; }
		public function get hFunction():String { return o.hFunction; }
		public function get nTitle():String { return o.nTitle; }
		public function get active():Boolean { return o.active; }
		public function get id():String { return o.id; }
		public function get originalID():String { return o.originalID; }
		public function get parent():String { return o.parent; }
		public function get nText():String { return o.nText; }
		public function get name():String { return o.name; }
		public function get colour():uint { return o.colour; }
		public function get nFunction():String { return o.nFunction; }
		public function get drag():Boolean { return o.drag; }
		public function get hName():String { return o.hName; }
		public function get receiver():Boolean { return o.receiver; }
		public function get child():String { return o.child; }
		public function get gloRef():String { return o.gloRef; }
		
		// unsure of the actual type used by this value
		// may be XMLString - see PatternsModel.createNode()
		public function get page():Object { return o.page; }
		

		// ----------------------------------------------------
		// IPatternNode Implementation - SETTERS
		// ----------------------------------------------------
		
		public function set loc(value:Point):void { o.loc = value; }
		public function set rootNode(value:Boolean):void { o.rootNode = value; }
		public function set hFunction(value:String):void { o.hFunction = value; }
		public function set nTitle(value:String):void { o.nTitle = value; }
		public function set active(value:Boolean):void { o.active = value; }
		public function set id(value:String):void { o.id = value; }
		public function set originalID(value:String):void { o.originalID = value; }
		public function set parent(value:String):void { o.parent = value; }
		public function set nText(value:String):void { o.nText = value; }
		public function set name(value:String):void { o.name = value; }
		public function set colour(value:uint):void { o.colour = value; }
		public function set nFunction(value:String):void { o.nFunction = value; }
		public function set drag(value:Boolean):void { o.drag = value; }
		public function set hName(value:String):void { o.hName = value; }
		public function set receiver(value:Boolean):void { o.receiver = value; }
		public function set child(value:String):void { o.child = value; }
		public function set gloRef(value:String):void { o.gloRef = value; }
		
		// unsure of the actual type used by this value
		// may be XMLString - see PatternsModel.createNode()
		public function set page(value:Object):void { o.page = value; }

	}
}