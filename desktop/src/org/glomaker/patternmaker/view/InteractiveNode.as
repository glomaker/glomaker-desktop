/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	
	import org.glomaker.patternmaker.events.*;

	/**
	 * The basic node with interactive buttons for connecting to other nodes. 
	 * @author USER
	 * 
	 */
	public class InteractiveNode extends Node {

		public static const EXTRACT_NODE:String = "extractNode";
		public static const DELETE_NODE:String = "deleteNode";
		public static const DELETE_ALL:String = "deleteAll";
		// public static const MAKE_ACTIVE_STRING:String = "makeActiveString";
		public static const NODE_OVER:String = "nodeOver";
		public static const NODE_OUT:String = "nodeOut";
		public static const NODE_UP:String = "nodeUp";
		
		/**
		 * Stores the custom context menu.
		 */
		private var _menuObj:CustomContextMenu;
		
		/**
		 * Stores the context menu to handle right-clicks. 
		 */
		private var _customMenu:ContextMenu;
		
		/**
		 * Stores a reference to this node's child, if one exists. 
		 */
		private var _child:Node;
		
		/**
		 * Constructor. 
		 * @param sqr
		 * @param c
		 * 
		 */
		public function InteractiveNode(sqr:uint, c:uint) {
			
			super(sqr, c);
			
			makeContextMenu();
			addConnectionFeatures();
			_child = null;
		}
		
		/**
		 * Enable the context menu to capture right-clicks. 
		 * 
		 */
		protected function makeContextMenu():void
		{
			_menuObj = new CustomContextMenu();
			_menuObj.addEventListener(MenuEvent.MENU_ITEM, onNodeRightClick);
			_customMenu = _menuObj.getCustomMenu;
		}
		
		/**
		 * Make the node interactive. 
		 * 
		 */
		protected function addConnectionFeatures():void {

			node.contextMenu = _customMenu;

			node.addEventListener(MouseEvent.MOUSE_DOWN, onNodeDown);
			node.addEventListener(MouseEvent.MOUSE_UP, onNodeUp);
			node.addEventListener(MouseEvent.MOUSE_OVER, onNodeOver);
			node.addEventListener(MouseEvent.MOUSE_OUT, onNodeOut);
			
			//this.addChild(node);

			var lowerConnector:Sprite = new Sprite();
			lowerConnector.name = "lowerConnector";
			lowerConnector.graphics.beginFill(0x000000);
			lowerConnector.graphics.drawRect(-sqrSize / 2, (sqrSize / 2) - 4, sqrSize, 4);
			lowerConnector.graphics.endFill();

			lowerConnector.graphics.beginFill(0x000000);
			lowerConnector.graphics.drawCircle(0, sqrSize / 2, 4);
			lowerConnector.graphics.endFill();
			lowerConnector.buttonMode = true;

			// lowerConnector.addEventListener(MouseEvent.MOUSE_DOWN, onlowerConnectorDown);
			// lowerConnector.addEventListener(MouseEvent.MOUSE_UP, onlowerConnectorUp);

			this.addChild(lowerConnector);

			var upperConnector:Sprite = new Sprite();
			upperConnector.name = "upperConnector";
			upperConnector.graphics.beginFill(0x000000);
			upperConnector.graphics.drawCircle(0, -sqrSize / 2, 4);
			upperConnector.graphics.endFill();
			upperConnector.buttonMode = true;

			//upperConnector.addEventListener(MouseEvent.MOUSE_DOWN, onUpperConnectorDown);
			//upperConnector.addEventListener(MouseEvent.MOUSE_UP, onUpperConnectorUp);

			this.addChild(upperConnector);

			this.setChildIndex(upperConnector, 0);
		}
		
		/**
		 * Make draggable.
		 * @param e
		 * 
		 */
		protected function onNodeDown(e:MouseEvent):void
		{
			// constrain to visible area of parent so we don't lose it by mistake
			// the node is inside
			
			
			var rect:Rectangle;
			var h:int;
			
			try{
				//the node should be in a sprite, which is in the 'container', which is in the window, which has a scrollrect 
				rect = parent.parent.parent.scrollRect;
				h = rect.height;
				
				var corner:Point = rect.topLeft.clone();
				corner = parent.parent.parent.localToGlobal( corner );
				corner = parent.globalToLocal( corner );
				
				rect.topLeft = corner;
				rect.height = h;
				
			}catch(e:Error){}

			startDrag(false, rect);
		}
		
		/**
		 * Responds to mouse up events. 
		 * @param e
		 * 
		 */
		protected function onNodeUp(e:MouseEvent):void
		{
			stopDrag();
		}
		
		/**
		 * Responds to the user righ-clicking on a node. 
		 * @param evt
		 * 
		 */
		protected function onNodeRightClick(evt:MenuEvent):void
		{
			var action:String = evt.message.split("_")[1];
			var targetName:String = evt.message.split("_")[0];
	
			switch(action)
			{
				case "Extract Node":
					dispatchEvent(new Event(EXTRACT_NODE));
					break;
					
				case "Delete Node":
					dispatchEvent(new Event(DELETE_NODE, true));
					break;
					
				case "Delete All":
					dispatchEvent(new Event(DELETE_ALL, true));
					break;
					
				/* case "Make Active Sequence":
					dispatchEvent(new Event(MAKE_ACTIVE_STRING));
					break; */
			}
		}
		
		/**
		 * Responds to mouse over events. 
		 * @param evt
		 * 
		 */
		protected function onNodeOver(evt:MouseEvent):void{
			dispatchEvent(new Event(NODE_OVER));
		}
		
		/**
		 * Responds to mouse out events. 
		 * @param evt
		 * 
		 */
		protected function onNodeOut(evt:MouseEvent):void{
			dispatchEvent(new Event(NODE_OUT));
		}
		
		/**
		 * Each node can have one child attached. A reference to this can be stored. 
		 * @param c
		 * 
		 */
		public function set child(c:Node):void
		{
			_child = c;
		}
				
		/**
		 * Returns a reference to this node's child, if one exists. 
		 * @return 
		 * 
		 */
		public function get child():Node
		{
			return _child;
		}
		
		/**
		 * Carries out any clean up operations required. 
		 * 
		 */
		public function cleanUp():void
		{
			_menuObj.removeEventListener(MenuEvent.MENU_ITEM, onNodeRightClick);
			node.removeEventListener(MouseEvent.MOUSE_DOWN, onNodeDown);
			node.removeEventListener(MouseEvent.MOUSE_UP, onNodeUp);
			node.removeEventListener(MouseEvent.MOUSE_OVER, onNodeOver);
			node.removeEventListener(MouseEvent.MOUSE_OUT, onNodeOut);
		}
		
		/**
		 * Resets the node. 
		 * 
		 */
		public function reset():void
		{
			stopDrag();
			
			graphics.clear();
		}
		/* private function onNodeRightClick(e:MenuEvent):void{
			this.dispatchEvent(e);
		}
		private function onNodeDown(e:MouseEvent):void{
			this.dispatchEvent(e);
		}
		private function onNodeUp(e:MouseEvent):void{
			//trace("NODEUP");
			//this.dispatchEvent(e));
		}
		private function onNodeOver(e:MouseEvent):void{
			this.dispatchEvent(e);
		}
		private function onNodeOut(e:MouseEvent):void{
			this.dispatchEvent(e);
		}
		private function onlowerConnectorDown(e:MouseEvent):void{
			this.dispatchEvent(e);
		}
		private function onlowerConnectorUp(e:MouseEvent):void{
			this.dispatchEvent(e);
		} */
		
	}
}