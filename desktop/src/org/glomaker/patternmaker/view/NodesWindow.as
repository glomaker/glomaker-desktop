/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.printing.PrintJob;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	
	import mx.core.Application;
	
	import org.glomaker.app.view.patternmaker.PatternMakerView;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.interfaces.pattern.PatternNode;
	import org.glomaker.patternmaker.controller.*;
	import org.glomaker.patternmaker.data.GlobalPoint;
	import org.glomaker.patternmaker.events.*;
	import org.glomaker.patternmaker.model.IBaseModel;
	import org.glomaker.patternmaker.model.IPatternsModel;
	import org.glomaker.patternmaker.model.PatternsModel;
	
	
	public class NodesWindow extends ComponentView
	{	
		private var _stage:Stage;
		private var _container:Sprite;
		private var _window:Sprite;
		private var _nodeContainer:Sprite;
		private var _drawLayer:ConnectLayer;
		private var _customMenu:ContextMenu;
		
		private var _menuHeight:uint;
		private var _scrollWindowHeight:uint;
		private var _insetH:uint;
		private var _insetV:uint;
		private var _stageDown:Boolean;
		private var _mouseD:Boolean;
		private var _newNode:String;
		private var _myPJ:PrintJob;
		
		public function NodesWindow(aModel:IBaseModel, aStage:Stage, aController:Object = null)
		{
			super(aModel, aController);
			
			_stage = aStage;
			
			_menuHeight = 500;
			_scrollWindowHeight = 480;
			
			// create a container to which all the necessary assets can be appended.
			// since this whole area is intended to be draggable, it is made large enough to
			// receive mouse clicks once already dragged around			
			makeContainer();
					
			// if the container were displayed "as is" it would cover over the whole UI.
			// for this reason it is made the child of another sprite with a scrollRect defined.
			// effectively this makes a window that crops the container	
			makeWindow();
			
			// add the drag window as a child		
			addChild(_window);
			
			// add the container as a child of the window, so that it is cropped
			_window.addChild(_container);
			
			// the connections between nodes are handled by ConnectLayer. Add this to the container
			_drawLayer = new ConnectLayer(aModel, aStage, aController);
			_drawLayer.name = "drawLayer";
			_container.addChild(_drawLayer as Sprite);
			
			// make a sprite to contain all the nodes	
			makeNodeContainer();
			
			
			// to ensure all mouse up events are captured, add an event listener to the stage	
			_stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
			
			_nodeContainer.name = "nodeContainer";
			_container.addChild(_nodeContainer);
			
			//container.scaleX = .5;
			//container.scaleY = .5;
			
			
			//The height the nodes appear relative to the top of their container
			_insetV = 60;
			
			//The horizontal distance the nodes appear relative to the left of their container
			_insetH = 80;
			
			_mouseD = false;
			
			_newNode = null;
			
		}

		protected function makeContainer():void
		{
			// create container sprite
			_container = new Sprite();
			_container.name = "container";
			
			// will not receive mouse clicks unless a graphics has been drawn
			_container.graphics.lineStyle(5, 0, .2);
			_container.graphics.beginFill(0xff0000, 0);
			
			// ensure the graphic covers a sufficently wide area
			_container.graphics.drawRect(-2500, -2500, 5000, 5000);
			
			// add listeners to detect mouse down and mouse up events. Used to move pane and associated assets
			_container.addEventListener(MouseEvent.MOUSE_DOWN, onContainerDown);
			_container.addEventListener(MouseEvent.MOUSE_UP, onContainerUp);
		}
		
		/**
		 * Makes the window. 
		 */
		protected function makeWindow():void
		{
			// create drag window
			_window = new Sprite();
			_window.name = "dragWindow";
			_window.mouseEnabled = false;
			
			// set up scrollRect property so that sprite acts like a window, cropping the container sprite
			_window.scrollRect = new Rectangle(0, 0, 800, 800);
		}
		
		/**
		 * Make the node container. 
		 * 
		 */
		protected function makeNodeContainer():void
		{
			_nodeContainer = new Sprite();
			_nodeContainer.name = "nodeContainer";
			_container.addChild(_nodeContainer);
			
		}
		
		/**
		 * Respond to whenever the user clicks down anywhere on the container. 
		 * @param evt
		 * 
		 */
		protected function onContainerDown(evt:MouseEvent):void
		{
			if(evt.target.name == "container")
			{
				_container.startDrag();
			}
			
		}
		
		/**
		 * Respond to whenever the user clicks up anywhere on the container. 
		 * @param evt
		 * 
		 */
		protected function onContainerUp(evt:MouseEvent):void
		{
			_container.stopDrag();
			
			_mouseD = false;
			
			if(evt.target.name != "explainText" && evt.target.name != "titleText")
			{
				setAllNodesLocationsOnModel();
			}
			
		}
		
		////////////////////////////////////////////////////////////
		//
		// ALL FUNCTIONS RELATING TO NODES GOES BELOW
		//
		////////////////////////////////////////////////////////////
		
		/**
		 * The main function. Creates Nodes. 
		 * 
		 */
		protected function createNodes():void 
		{	
		
			// clear all presently existing nodes
			clearNodes();
		
			// get a reference to the array of nodes, as they currently stand	
			var nodeArray:Array = (model as PatternsModel).getNodeArray();
			var sqrSize:int = (model as IPatternsModel).getNodeHeight();
			// if there are no nodes to display, do nothing
			if (nodeArray.length == 0)
			{
				return;
			}
			
			// code below may be useful for adding a root node
			/* var rootFound:Boolean = false; */

			for each(var node:IPatternNode in nodeArray)
			{	
				
				// code below may be useful for adding a root node
				/* if(nodeArray[i].id == "rootNode" && rootFound == false)
				{
					rootFound = true;
	
				}else if(nodeArray[i].id == "rootNode" && rootFound == true)
				{
					continue;
				} */
				
				var nodeGroup:DescriptionNode01 = new DescriptionNode01(sqrSize, node.func.heading.colour);
				(nodeGroup as Sprite).name = node.id;
				
				// if(nodeArray[i].id == (model as IPatternsModel).getActiveSequence()){
					// UNCOMMENT FOR "root" TEXT
					// nodeGroup.setRootNodeText("Active Nodes");
				// }
				
				//Only Freestyle title text can be editable
				/* if(nodeArray[i].nFunction != "generic"){
					
					nodeGroup.setTitleEditable(false);
				} */
				nodeGroup.setTitleEditable((model as IPatternsModel).nodeTitleEditing);
				
				nodeGroup.setTitleText(node.title);
				nodeGroup.setExplainText(node.description);
				
				_nodeContainer.addChild(nodeGroup);
				
				// Here is the beginning of the problem area. What has to happen is that all locations
				// stored in the model, should be GLOBAL. They should be converted to LOCAL when APPLIED

				var localCoordinates:Point = _container.globalToLocal(new Point(node.loc.x, node.loc.y));

				nodeGroup.x = localCoordinates.x;
				nodeGroup.y = localCoordinates.y;

				// we need to make sure these are removed...
				nodeGroup.addEventListener(InteractiveNode.EXTRACT_NODE, onNodeRightClick);
				// nodeGroup.addEventListener(InteractiveNode.MAKE_ACTIVE_STRING, onNodeRightClick);
				nodeGroup.addEventListener(InteractiveNode.NODE_OVER, onNodeOver);
				nodeGroup.addEventListener(InteractiveNode.NODE_OUT, onNodeOut);
				nodeGroup.addEventListener(MouseEvent.MOUSE_DOWN, onNodeDown);
				nodeGroup.addEventListener(MouseEvent.MOUSE_UP, onNodeUp);

				// these are now handled by PatternMaker class
				// nodeGroup.addEventListener(InteractiveNode.DELETE_NODE, onNodeRightClick);
				// nodeGroup.addEventListener(InteractiveNode.DELETE_ALL, onNodeRightClick);

				
				nodeGroup.addEventListener(Event.CHANGE, onChangeText);
				
				// temporary measure to ensure no error occur
				//
				//
				makeActiveSequence();
				//
				//
				// temporary measure to ensure no error occur
			}
			
			// code below may be useful for adding a root node
			/* if(!rootFound)
			{
				(model as IPatternsModel).createNode("rootNode", new GlobalPoint(200, 100));
			} */
		}
		
		/**
		 * Clears all nodes. 
		 * 
		 */
		protected function clearNodes():void {
			
			for (var i:uint=0; i<_nodeContainer.numChildren; i++)
			{
				var nodeGroup:InteractiveNode = _nodeContainer.getChildAt(i) as InteractiveNode;
				
				if(nodeGroup != null)
				{
					nodeGroup.cleanUp();
				
					// remove any event listeners
					nodeGroup.removeEventListener(InteractiveNode.DELETE_NODE, onNodeRightClick);
					nodeGroup.removeEventListener(InteractiveNode.DELETE_ALL, onNodeRightClick);
					nodeGroup.removeEventListener(InteractiveNode.EXTRACT_NODE, onNodeRightClick);
					// nodeGroup.removeEventListener(InteractiveNode.MAKE_ACTIVE_STRING, onNodeRightClick);
					nodeGroup.removeEventListener(InteractiveNode.NODE_OVER, onNodeOver);
					nodeGroup.removeEventListener(InteractiveNode.NODE_OUT, onNodeOut);
					nodeGroup.removeEventListener(MouseEvent.MOUSE_DOWN, onNodeDown);
					nodeGroup.removeEventListener(MouseEvent.MOUSE_UP, onNodeUp);
					
					nodeGroup.removeEventListener(Event.CHANGE, onChangeText);
					
					// remove node	
					_nodeContainer.removeChildAt(i);
					
					i--;
				}
				
			}
		}
		
		/**
		 * If a node is connectable, make this apparent to the user by deforming the node. 
		 * @param h
		 * 
		 */
		protected function highlightReceiver(h:Boolean):void
		{
			//Find active receiver
			if(h)
			{
				
			//Find the active receiver and deform node for user feedback
			var receiverNode:IPatternNode = null;
			
			// get the node array from the model
			var nodeArray:Array = (model as PatternsModel).getNodeArray();
			
			for each(var node:IPatternNode in nodeArray)
			{
				if(node.isReceiver)
				{
					receiverNode = node;
					break;
				}
			}
			
			var receiver:DisplayObject;
			var nodeSprite:DisplayObject;
			
				if(receiverNode)
				{
					receiver = findNodeInDisplayList(receiverNode.id);
					nodeSprite = (receiver as Sprite).getChildByName("node");
				}
			
				if(receiver)
				{
					// deform
					nodeSprite.scaleX = 1.4;
				}
				
			}else{
				//Reset all nodes
				for(var i:uint=0; i<_nodeContainer.numChildren; i++){	
							
					(_nodeContainer.getChildAt(i) as Sprite).getChildByName("node").scaleX = 1;
				}
			}

		}

		/**
		 * Returns a node in the DisplayList from a given nodeID.
		 * @param nodeID
		 * @return 
		 * 
		 */
		protected function findNodeInDisplayList(nodeID:String):DisplayObject 
		{

			var node:DisplayObject = null;
			
			for (var i:uint=0; i<_nodeContainer.numChildren; i++)
			{
				if (_nodeContainer.getChildAt(i).name == nodeID)
				{
					node = _nodeContainer.getChildAt(i);
					break;
				}
			}
			
			return node;
		}
		
		/**
		 * Whenever the nodes are shifted by the user, en masse, their new positions are recorded. 
		 * 
		 */
		protected function setAllNodesLocationsOnModel():void
		{
			for(var i:uint=0; i<_nodeContainer.numChildren; i++)
			{
				if(_nodeContainer.getChildAt(i) is Node)
				{
					var node:Node = _nodeContainer.getChildAt(i) as Node;
					var loc:Point = _nodeContainer.localToGlobal(new Point(node.x, node.y));
					
					var globalCoordinates:GlobalPoint = new GlobalPoint(loc.x, loc.y);
					
					(controller  as  IPatternsController).setLoc(node.name, globalCoordinates);
				}
			}
		}
		
		/**
		 * Respond to mouse movement.
		 * @param e
		 * 
		 */
		protected function onStageMove(e:MouseEvent):void 
		{
			// causing too many events to be handled.
			
			if(_mouseD)
			{
				_drawLayer.connect(_nodeContainer);
				_drawLayer.drawLine(_container);
			}
			
		}
		
		/**
		 * Responds to any stage up event. 
		 * @param evt
		 * 
		 */
		protected function onStageUp(evt:MouseEvent):void
		{	
			
			// stop the container from dragging
			_container.stopDrag();
			
			// stop line from being drawn
			_drawLayer.clearDraggableLine();
			
			// reset all interactive nodes
			for(var i:uint=0; i<_nodeContainer.numChildren; i++)
			{
				if(_nodeContainer.getChildAt(i) is InteractiveNode)
				{
					(_nodeContainer.getChildAt(i) as InteractiveNode).reset();
				}
			}
			
			if(evt.target is TextField){
				
				return;
			}
			
			
			highlightReceiver(false);
			
			_mouseD = false;
	
		}
		
		/**
		 * Responds to the user righ-clicking on a node. 
		 * @param evt
		 * 
		 */
		protected function onNodeRightClick(evt:Event):void
		{
			//Delegate to controller
			var action:String = evt.type;
			var targetName:String = (evt.target as Sprite).name;
	
			switch(action)
			{
				case InteractiveNode.EXTRACT_NODE:
					(controller  as  IPatternsController).extractNode(targetName);
					(evt.target as Sprite).x += 20;
					break;
					
				case InteractiveNode.DELETE_NODE:
					// this event is now handled by PatternMaker itself
					// (controller  as  IPatternsController).removeNode(targetName);
					break;
					
				case InteractiveNode.DELETE_ALL:
					// this event is now handled by PatternMaker itself
					// (controller  as  IPatternsController).removeAllNodes();
					break;
					
				/* case InteractiveNode.MAKE_ACTIVE_STRING:
					(controller  as  IPatternsController).makeActiveSequence(targetName);
					break; */
			}
		} 
		
		/**
		 * Responds to when a user clicks down on a node.  
		 * @param evt
		 * 
		 */
		protected function onNodeDown(evt:MouseEvent):void
		{
			switch(evt.target.name)
			{
				case "lowerConnector":
					
					(controller  as  IPatternsController).setActiveNode(true, evt.currentTarget.name);
					break;
				
			}
			
			
			
			_mouseD = true;
		}
		
		/**
		 * Responds to when a user clicks up on a node. 
		 * @param evt
		 * 
		 */
		protected function onNodeUp(evt:MouseEvent):void
		{
			switch(evt.target.name)
			{			
				case "node":
					(controller  as  IPatternsController).setConnection();
					var node:Sprite = (evt.currentTarget as Sprite);
					
					var x:int = (evt.currentTarget as Sprite).x;
					var y:int = (evt.currentTarget as Sprite).y;
				
					var loc:Point = node.localToGlobal(new Point(x, y));
										
					var globalCoordinates:GlobalPoint = new GlobalPoint(loc.x, loc.y);
					
					var scrollW:int = _window.scrollRect.width;
					var scrollH:int = _window.scrollRect.height;
					var scrollTL:Point = localToGlobal(new Point(_window.scrollRect.left, _window.scrollRect.top));
													
					
					(controller  as  IPatternsController).setLoc(node.name, globalCoordinates);
					
					
					break;
			}
			
			_mouseD = false;
		}
		
		/**
		 * Responds to when a user drags over a node. 
		 * @param evt
		 * 
		 */
		protected function onNodeOver(evt:Event):void
		{
			(controller  as  IPatternsController).setReceiver(true, (evt.target as Sprite).name);
		}
		
		/**
		 * Responds to when a user drags out of a node.
		 * @param evt
		 * 
		 */
		protected function onNodeOut(evt:Event):void
		{
			(controller  as  IPatternsController).setReceiver(false, (evt.target as Sprite).name);
		}
		
		
		/**
		 * Responds to whenever the user changes some text in the explain field. 
		 * @param evt
		 * 
		 */
		protected function onChangeText(evt:Event):void
		{
			if(evt.target is TextField)
			{
				switch(evt.target.name)
				{
					case "titleText":
						(controller  as  IPatternsController).setTitleText(evt.currentTarget.name, evt.target.text);
						break;
						
					case "explainText":
						(controller  as  IPatternsController).setExplainText(evt.currentTarget.name, evt.target.text);
						break;
				}
			}
		}
		
		/**
		 * Determines which sequence of connected nodes is to be carried over to the Designer.
		 * This function is very basic. It simply chooses the first node it finds and arbitrarily makes
		 * that one the determinant of the active string. This is not really satisfactory and 
		 * has been raised as an issue for future improvement.
		 *  
		 * 
		 */
		protected function makeActiveSequence():void
		{
			if(_nodeContainer.numChildren > 0)
			{
				(controller as IPatternsController).makeActiveSequence(_nodeContainer.getChildAt(0).name);
			}
			
		}
		
		/**
		 * Carries out the vertical alignment of nodes. 
		 * 
		 */
		public function alignNodes():void
		{
			
			// get the nodeArray
			var nodeArray:Array = (model as IPatternsModel).getNodeArray();
			var parentArray:Array = [];
			
			// work through array to find any nodes whose parent is null and therefore must be at the top
			// of a string
			for(var i:uint=0; i<nodeArray.length; i++)
			{
				var pn:PatternNode = nodeArray[i];
				
				if(pn.parentId == null)
				{
					parentArray.push(pn);
				}
			}
			
			var child:IPatternNode;
			var parentLoc:GlobalPoint;
			var loc:GlobalPoint;
			var nodeHeight:uint;
			
			// use the parent nodes to find all the connected strings
			for(i=0; i<parentArray.length; i++)
			{
				child = (model as IPatternsModel).getChild((parentArray[i] as PatternNode).id);
				parentLoc = (parentArray[i] as PatternNode).loc;
				nodeHeight = _nodeContainer.getChildByName((parentArray[i] as PatternNode).id).height + 10;
					
					// recursively dig for child nodes
					while(child != null)
					{
						// establish the new position of each node
						loc = new GlobalPoint(parentLoc.x, parentLoc.y + nodeHeight);
						
						// make sure the model is updated via the controller
						(controller as IPatternsController).setLoc(child.id, loc);
						
						// set the node height here so that it is stored for the next iteration
						nodeHeight += _nodeContainer.getChildByName(child.id).height + 10;
						
						// find the next child
						child = (model as IPatternsModel).getChild(child.id);	
					}
	
			}
			
			// recreate the nodes and redraw the strings
			createNodes();
			_drawLayer.connect(_nodeContainer);
		}
		
		public function printSetup():void
		{
			// this has to be a two-stage operation since changing the size of the application
			// has no effect on the printed page until all the changes have been implemented within Flex
			
			// create PrintJob object
			_myPJ = new PrintJob();
			
			// display Print dialog box, but only initiate the print job
			// if start returns successfully.
			
			if (_myPJ.start()) 
			{	
				// scale page to fit print page width
				var pWidth:int = _myPJ.pageWidth;
				var pHeight:int = _myPJ.pageHeight;
				
				var pm:PatternMakerView = Application.application.patternMaker as PatternMakerView;
				
				var scaleFactorW:Number = pWidth / (pm as Sprite).width;
				var scaleFactorH:Number = pHeight / (pm as Sprite).height;
				
				var scaleFactor:Number;
				
				if(scaleFactorW <= scaleFactorH)
				{
					scaleFactor = scaleFactorW;
				}else
				{
					scaleFactor = scaleFactorH;
				}
				
				(pm as Sprite).scaleX = scaleFactor;
				(pm as Sprite).scaleY = scaleFactor;
				
				pm.invalidateDisplayList();
				
			}
		}
		
		/**
		 * Prints the page containing nodes. 
		 * 
		 */
		public function printNodes():void
		{

			try 
			{
				var pm:PatternMakerView = Application.application.patternMaker as PatternMakerView;
					
				_myPJ.addPage(pm as Sprite);
				
				(pm as Sprite).scaleX = 1;
				(pm as Sprite).scaleY = 1;
					
			} catch (e:Error) {
				trace(e.message);
			}
				
			_myPJ.send();

			
			
		}
		
		/**
		 * Responds to events within the MVC framework. 
		 * @param e
		 * 
		 */
		override public function update(e:ModelEvent = null):void 
		{
			
			switch(e.message){

				case "removeAllNodes":
					_drawLayer.clearAll();
					createNodes();
					break;
				case "removeNode":
					createNodes();
					_drawLayer.connect(_nodeContainer);
					break;
				case "createNode":
					createNodes();
					_drawLayer.connect(_nodeContainer);
					break;
				case "buildInstance":
					createNodes();	
					makeActiveSequence();
					alignNodes();
					break;
				case "setReceiverTRUE":
					highlightReceiver(true);
					break;
				case "setReceiverFALSE":
					highlightReceiver(false);
					break;
				case "makeActiveSequence":
					// createNodes();
					break;
				case "setTitleText":
					//trace("TEXT");
					break;
				case "setExplainText":
					//trace("title");
					break;
				case "deactivateNodes":
					_drawLayer.connect(_nodeContainer);
					break;
				case "extractNode":
					_drawLayer.connect(_nodeContainer);
					break;
			}

		}
	}
}