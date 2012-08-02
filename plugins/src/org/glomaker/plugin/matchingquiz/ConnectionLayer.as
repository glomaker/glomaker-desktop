package org.glomaker.plugin.matchingquiz
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	
	/**
	 * Dispatched when the connections change.
	 */
	[Event(name="change", type="flash.events.Event")]
	
	[Style(name="color", type="uint", format="Color", inherit="yes")]
	
	/**
	 * Manages the display and creation of connections between the quiz elements based on user
	 * interaction.
	 * 
	 * @author haykel
	 * 
	 */
	public class ConnectionLayer extends UIComponent
	{
		//--------------------------------------------------
		// Private vars
		//--------------------------------------------------
		
		private var connectionsShape:Shape;
		private var currentConnectionShape:Shape;
		
		private var currentSource:ListItem;
		
		//--------------------------------------------------
		// Initialization
		//--------------------------------------------------
		
		public function ConnectionLayer()
		{
			super();
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		//--------------------------------------------------
		// sources
		//--------------------------------------------------
		
		private var _sources:Array = [];
		private var sourcesChanged:Boolean;

		/**
		 * List of elements used as sources of user interactions.
		 */
		public function get sources():Array
		{
			return _sources;
		}

		/**
		 * @private
		 */
		public function set sources(value:Array):void
		{
			if (value == sources)
				return;
			
			var item:ListItem
			for each (item in sources)
			{
				if (item)
				{
					item.removeEventListener(MouseEvent.MOUSE_OVER, source_mouseOverHandler);
					item.removeEventListener(MouseEvent.MOUSE_OUT, source_mouseOutHandler);
					item.removeEventListener(MouseEvent.MOUSE_DOWN, source_mouseDownHandler);
				}
			}
			
			_sources = value ? value : [];
			
			for each (item in sources)
			{
				if (item)
				{
					item.addEventListener(MouseEvent.MOUSE_OVER, source_mouseOverHandler);
					item.addEventListener(MouseEvent.MOUSE_OUT, source_mouseOutHandler);
					item.addEventListener(MouseEvent.MOUSE_DOWN, source_mouseDownHandler);
				}
			}
			
			sourcesChanged = true;
			invalidateProperties();
		}
		
		//--------------------------------------------------
		// destinations
		//--------------------------------------------------
		
		private var _destinations:Array = [];
		private var destinationsChanged:Boolean;

		/**
		 * List of elements used as destinations of user interactions.
		 */
		public function get destinations():Array
		{
			return _destinations;
		}

		/**
		 * @private
		 */
		public function set destinations(value:Array):void
		{
			if (value == destinations)
				return;
			
			var item:ListItem;
			for each (item in destinations)
			{
				if (item)
				{
					item.removeEventListener(MouseEvent.MOUSE_OVER, destinations_mouseOverHandler);
					item.removeEventListener(MouseEvent.MOUSE_OUT, destinations_mouseOutHandler);
					item.removeEventListener(MouseEvent.MOUSE_UP, destinations_mouseUpHandler);
				}
			}
			
			_destinations = value ? value : [];

			for each (item in destinations)
			{
				if (item)
				{
					item.addEventListener(MouseEvent.MOUSE_OVER, destinations_mouseOverHandler);
					item.addEventListener(MouseEvent.MOUSE_OUT, destinations_mouseOutHandler);
					item.addEventListener(MouseEvent.MOUSE_UP, destinations_mouseUpHandler);
				}
			}
			
			destinationsChanged = true;
			invalidateProperties();
		}

		
		//--------------------------------------------------
		// connections
		//--------------------------------------------------
		
		protected var _connections:Array = [];

		/**
		 * List of current connections. Keys are indices in the sources list, values are indices
		 * in the destinations list.
		 */
		public function get connections():Array
		{
			return _connections;
		}
		
		//--------------------------------------------------
		// connectionCount
		//--------------------------------------------------
		
		private var _count:uint;
		
		[Bindable(event="propertyChange")]
		/**
		 * Number of connections made by the user.
		 */
		public function get count():uint
		{
			return _count;
		}
		
		protected function setCount(value:uint):void
		{
			if (value == count)
				return;
			
			var old:uint = count;
			_count = value;
			
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "count", old, value));
		}
		
		//--------------------------------------------------
		// Protected functions
		//--------------------------------------------------
		
		protected function resetConnections():void
		{
			var changed:Boolean = false;
			
			if (connections.length != sources.length)
			{
				connections.length = sources.length;
				changed = true;
			}
			
			for (var i:uint=0; i < connections.length; i++)
			{
				if (connections[i] != -1)
				{
					connections[i] = -1;
					changed = true;
				}
			}
			
			if (changed)
			{
				updateConnections();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function setConnection(source:uint, destination:uint):void
		{
			if (source < sources.length && destination < destinations.length && connections[source] != destination)
			{
				connections[source] = destination;
				
				for (var i:uint=0; i < connections.length; i++)
				{
					if (i != source && connections[i] == destination)
						connections[i] = -1;
				}
				
				updateConnections();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function updateCurrentConnection(stageX:Number=NaN, stageY:Number=NaN):void
		{
			var g:Graphics = currentConnectionShape.graphics;
			
			g.clear();
			g.lineStyle(2, getStyle("color"));
			
			if (currentSource && !isNaN(stageX) && !isNaN(stageY))
			{
				var anchor:Anchor = currentSource.anchor;
				var p1:Point = currentConnectionShape.globalToLocal(anchor.localToGlobal(new Point(anchor.width / 2, anchor.height / 2)));
				var p2:Point = currentConnectionShape.globalToLocal(new Point(stageX, stageY));
				
				g.moveTo(p1.x, p1.y);
				g.lineTo(p2.x, p2.y);
			}
		}
		
		protected function updateConnections():void
		{
			var g:Graphics = connectionsShape.graphics;
			
			g.clear();
			g.lineStyle(2, getStyle("color"));
			
			var c:uint = 0;
			for (var i:uint=0; i < connections.length; i++)
			{
				if (connections[i] >= 0)
				{
					var anchor:Anchor = sources[i].anchor;
					var p1:Point = currentConnectionShape.globalToLocal(anchor.localToGlobal(new Point(anchor.width / 2, anchor.height / 2)));
					
					anchor = destinations[connections[i]].anchor;
					var p2:Point = currentConnectionShape.globalToLocal(anchor.localToGlobal(new Point(anchor.width / 2, anchor.height / 2)));
					
					g.moveTo(p1.x, p1.y);
					g.lineTo(p2.x, p2.y);
					
					c++;
				}
			}
			
			setCount(c);
		}
		
		//--------------------------------------------------
		// Overrides
		//--------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			connectionsShape = new Shape();
			addChild(connectionsShape);
			
			currentConnectionShape = new Shape();
			addChild(currentConnectionShape);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (sourcesChanged || destinationsChanged)
			{
				sourcesChanged = false;
				destinationsChanged = false;
				
				resetConnections();
			}
		}
		
		//--------------------------------------------------
		// Event handlers
		//--------------------------------------------------
		
		protected function source_mouseOverHandler(event:MouseEvent):void
		{
			if (!enabled || currentSource)
				return;
			
			var item:ListItem = event.currentTarget as ListItem;
			item.highlighted = true;
		}
		
		protected function source_mouseOutHandler(event:MouseEvent):void
		{
			if (!enabled || currentSource)
				return;
			
			var item:ListItem = event.currentTarget as ListItem;
			item.highlighted = false;
		}
		
		protected function source_mouseDownHandler(event:MouseEvent):void
		{
			if (!enabled || currentSource)
				return;
			
			var item:ListItem = event.currentTarget as ListItem;
			item.highlighted = false;
			currentSource = item;
			
			updateCurrentConnection(event.stageX, event.stageY);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		protected function destinations_mouseOverHandler(event:MouseEvent):void
		{
			if (!enabled || !currentSource)
				return;
			
			var item:ListItem = event.currentTarget as ListItem;
			item.highlighted = true;
		}
		
		protected function destinations_mouseOutHandler(event:MouseEvent):void
		{
			if (!enabled || !currentSource)
				return;
			
			var item:ListItem = event.currentTarget as ListItem;
			item.highlighted = false;
		}
		
		protected function destinations_mouseUpHandler(event:MouseEvent):void
		{
			if (!enabled || !currentSource)
				return;
			
			var item:ListItem = event.currentTarget as ListItem;
			item.highlighted = false;
			setConnection(sources.indexOf(currentSource), destinations.indexOf(item));
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void
		{
			updateCurrentConnection(event.stageX, event.stageY);
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			
			currentSource = null;
			updateCurrentConnection();
		}
	}
}