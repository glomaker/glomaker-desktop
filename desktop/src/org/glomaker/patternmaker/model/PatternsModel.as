﻿///////////////////////////////////////////////////////////
//  BaseModel.as
//  Macromedia ActionScript Implementation of the Class BaseModel
//  Generated by Enterprise Architect
//  Created on:      06-Nov-2007 13:48:23
//  Original author: USER
///////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.model
{
	import flash.display.Stage;
	import flash.events.*;
	
	import org.glomaker.interfaces.pattern.IPatternFunction;
	import org.glomaker.interfaces.pattern.IPatternHeading;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.interfaces.pattern.PatternNode;
	import org.glomaker.patternmaker.data.GlobalPoint;

	/**
	 * @author USER
	 * @version 1.0
	 * @created 06-Nov-2007 13:48:23
	 */
	
	
	public class PatternsModel extends BaseModel implements IPatternsModel 
	{
		/**
		     * CONSTRUCTOR
		     */
		
		protected static var id:uint;
		protected static var cmdParam:String ="";
		
		private var nodeHeight:uint;
		private var activeNode:String;
		private var _root:IPatternNode;
		private var _allowNodeTitleEditing:Boolean;
		private var _allowNodeExplainEditing:Boolean;
		
		
		public function PatternsModel(aStage:Stage) 
		{
			super(aStage);
			//nodeArray = new Array()
			id = 1;
			nodeHeight = 23;
	
		}
		
		
		/**
		 * Sets the menu and the node data at the same time. 
		 * @param menu Array of IPatternLibraryItem instances.
		 * @param nodes Array of IPatternNode instances.
		 */		 
		public function setMenuAndNodes(menu:Array, nodes:Array):void
		{
			// store a copy
			menuList = menu.concat();
			nodeArray = nodes.concat();
			
			// make sure ID counter will still produce unique IDs
			updateIDCounter();
			
			// notify
			update("buildInstance");
		}
		
		public function createNode(menuBtnID:String, loc:GlobalPoint, gloPage:XML = null):void
		{
			
			var menuBtnFunc:IPatternFunction = getMenuBtnFunc(menuBtnID);
			var nodeObj:IPatternNode = new PatternNode();
			
			// code below may be useful for adding a root node
			/* if(menuBtnID == "rootNode")
			{
				
				nodeObj.originalID = "rootNode";
				nodeObj.name = "rootNode";
				nodeObj.id = "rootNode";
				nodeObj.nFunction = "rootNode";
				nodeObj.colour = 0xff0000;
				nodeObj.nTitle = "rootNode";
				nodeObj.nText = "rootNode";
				nodeObj.hName = "rootNode";
				nodeObj.hFunction = "rootNode";
				nodeObj.layoutID = "rootNode";
				nodeObj.layoutList = [];
		
				nodeArray.unshift(nodeObj);
				
			}else
			{ */
			
			nodeObj.id = getNewNodeID();
			nodeObj.func = menuBtnFunc;
			nodeObj.title = menuBtnFunc.title;
			nodeObj.description = menuBtnFunc.description;
			
			nodeObj.layoutId = menuBtnFunc.defaultLayoutId;
			nodeObj.loc = loc;  // global coordinates
			
			nodeObj.parentId = null;
			nodeObj.childId = null;
			
			nodeObj.isActive = false;
			nodeObj.isReceiver = false;
			nodeObj.isRoot = false;
			
			nodeArray.push(nodeObj);


			this.update("createNode");

		}

		private function parseConnection(nodeID:String):Boolean{
			
			var baseNode:IPatternNode = getNode(nodeID);
			var activeNode:IPatternNode = null;
			var node:IPatternNode;
			
			//Get activeNode - if one exists
			for each(node in nodeArray)
			{
				if(node.isActive)
				{
					activeNode = node;
					break;
				}
			}
			
			//If there is no active node, return false
			if(!activeNode){
				return false;
			}
			
			//If the active node is also the receiver, return false
			if(activeNode.id == baseNode.id){
				return false;
			}			
			
			//Set all receiver to false. This ensures we are not checking one left over from previous action.
			for each(node in nodeArray)
			{
				node.isReceiver = false;
			}
			return true;
		}
		
		/**
		 * Updates the value of 'id' to be higher than ID values used by currently defined nodes.
		 * Call this method after updating 'nodeArray'.
		 * Assumes that the node IDs are a single character, followed by a number (eg. n1, n2, s99, b34) 
		 */		
		protected function updateIDCounter():void
		{
			var node:IPatternNode;
			var nodeIDValue:uint;
			var maxID:uint = 0;
			
			// loop through nodes and find the maximum number used as an ID suffix
			for each(node in nodeArray)
			{
				nodeIDValue = parseInt(node.id.substr(1));
				maxID = Math.max(maxID, nodeIDValue);
			}
			
			// found maximum ID value - next ID should use this value + 1
			id = maxID + 1;
		}
		
		
		/**
		 * Retrieves the ID value to use for a new node. 
		 * @return 
		 */		
		protected function getNewNodeID():String
		{
			var nextID:String = "n" + id;
			id++;
			return nextID;
		}
		
		
		
		public function setLoc(nodeID:String, loc:GlobalPoint):void{
			
			var node:IPatternNode = getNode(nodeID);
			node.loc = loc;
			
			update("setLoc");
		}
		
		public function getLoc(nodeID:String):GlobalPoint
		{
			var node:IPatternNode = getNode(nodeID);
			
			return node.loc as GlobalPoint;
		}
		
		public function getMenuBtnFunc(functionID:String):IPatternFunction
		{
			var func:IPatternFunction;
			var heading:IPatternHeading;
			var list:Array = getMenuList();
			
			for each(heading in list)
			{
				for each(func in heading.functions)
				{
					if(func.id == functionID)
					{
						// found a match
						return func;
					}
				}
			}
			
			// none found
			return null;
		}
		
		public function setActive(nodeID:String, active:Boolean):void{
			var node:IPatternNode = getNode(nodeID);
			node.isActive = active;
			update("setActive");
		}
		
		public function getActive(nodeID:String):Boolean{
			var node:IPatternNode = getNode(nodeID);
			return node.isActive;
		}
		public function setReceiver(nodeID:String, active:Boolean):void{
			var node:IPatternNode = getNode(nodeID);
			
			if(active){
				if(parseConnection(nodeID)){
					node.isReceiver = true;
					update("setReceiverTRUE");
				}else{
					node.isReceiver = false;
					update("setReceiverFALSE");
				}
			}else{
				node.isReceiver = false;
				update("setReceiverFALSE");
			}
			
		}
		public function getReceiver(nodeID:String):Boolean{
			var node:IPatternNode = getNode(nodeID);
			return node.isReceiver;
		}
		public function deactivateNodes():void{
			
			for each(var node:IPatternNode in nodeArray)
			{
				node.isActive = node.isReceiver = false;
			}
			update("deactivateNodes");
		}
		public function getNodeArray():Array{
			return nodeArray;
		}
		
		public function getNode(nodeID:String):IPatternNode
		{
			var node:IPatternNode;
			
			for each(node in nodeArray)
			{
				if(node.id == nodeID)
					return node;
			}
			
			// none found
			return null;
		}
		public function getNodeHeight():uint{
			return nodeHeight;
		}
		
		public function removeNode(nodeID:String):void{
			extractNode(nodeID);
			for(var i:uint=0; i<nodeArray.length; i++){
				if(nodeID == nodeArray[i].id){
					nodeArray.splice(i,1);
				}
			}
			update("removeNode");
		}
		public function extractNode(nodeID:String):void{
			var extractNode:IPatternNode = getNode(nodeID);
			var extractParent:IPatternNode = getNode(extractNode.parentId);
			var extractChild:IPatternNode = getNode(extractNode.childId);
			
			//There are four possibilites. The node may be the root node, the last node, a single node or it may be
			//embedded in a series of nodes.
			
			
		
			if (extractParent == null && extractChild == null) {
				//The node is a single. Nothing to extract.
				return;
			} else if (extractParent == null && extractChild != null) {
				//The node is the root node. Set its child's parent to null.
				extractChild.parentId = null;
			} else if (extractParent != null && extractChild != null) {
				//The node is in a series of nodes. Set the parent's child to the child's name. Set the child's parent to the parent's name.
				extractParent.childId = extractChild.id;
				extractChild.parentId = extractParent.id;
			} else if (extractParent != null && extractChild == null) {
				//The node is the last in a series. Set the parent's child to null.
				extractParent.childId = null;

			}
			//Set the nodes parent and child to null.
			extractNode.parentId = null;
			extractNode.childId = null;
			
			update("extractNode");
		}
		public function removeAllNodes():void{
			nodeArray = new Array();
			update("removeAllNodes");
		}
		
		public function duplicateNode(nodeID:String):IPatternNode
		{
			var refNode:IPatternNode = getNode(nodeID);
			var newNode:IPatternNode = refNode.clone(getNewNodeID());
			newNode.parentId = refNode.id;
			newNode.childId = refNode.childId;
			refNode.childId = newNode.id;
			
			nodeArray.push(newNode);
			update("duplicateNode");
			
			return newNode;
		}
		
		public function setConnection():void
		{
			//Determines whether connection can be made and sets parent child relationships.
			var activeNode:IPatternNode;
			var receiver:IPatternNode;
			
			//Find index of active node and receiver, if present.
			for each(var node:IPatternNode in nodeArray)
			{
				if(node.isActive)
				{
					activeNode = node;
				}
				
				if(node.isReceiver)
				{
					receiver = node;
				}
				
				if(activeNode && receiver)
					break; 
			}
			
			//If either activeNode or receiver are still set to false, no connection can be made
			if(activeNode == null || receiver == null){
				
				return;
			}
			
			//Set any orphaned nodes to null
			if(activeNode.childId != null)
			{
				var childNode:IPatternNode = getNode(activeNode.childId);
				
				if(childNode != null)
				{
					childNode.parentId = null;
				}				
			}
			
			if(receiver.parentId != null)
			{
				var parentNode:IPatternNode = getNode(receiver.parentId);
				
				if(parentNode != null)
				{
					parentNode.childId = null;
				}				
			}

			
			//Set child of active node and the parent of the receiving node.
			activeNode.childId = receiver.id;
			receiver.parentId = activeNode.id;
			
			deactivateNodes();
			update("setConnection");
		}
		public function drawLine():void{
			update("drawLine");
		}
		
		public function setChild(nodeID:String, childID:String = null):void {
			var node:IPatternNode = getNode(nodeID);
			node.childId = childID;
		}
		
		public function getChild(nodeID:String):IPatternNode
		{
			var node:IPatternNode = getNode(nodeID);
			return getNode(node.childId);
		}
		
		
		public function setParent(nodeID:String, parentID:String = null):void {
			var node:IPatternNode = getNode(nodeID);
			node.parentId = parentID;
		}
		
		public function getParent(nodeID:String):IPatternNode
		{
			var node:IPatternNode = getNode(nodeID);
			return getNode(node.parentId);
		}
		/* public function buildInstance():void{
			
			throw(new Event("BUILD"));
			update("buildInstance");
		} */
		public function setActiveSequence(nodeID:String):void{

			// find the starting node
			var rootNode:IPatternNode = getNode(nodeID);
			
			if(rootNode == null)
			{
				return;
			}

			// walk up the parent chain to find the root node of this sequence
			var node:IPatternNode;
			while(rootNode != null)
			{
				node = rootNode;
				rootNode = getNode(rootNode.parentId);
			}
			
			rootNode = node;
			
			// adjust node settings to match
			for each(node in nodeArray)
			{
				node.isRoot = (node == rootNode);
			}
			
			update("makeActiveSequence");
		}
		
		public function getActiveSequence():String
		{
			var activeNode:String;
			
			//Check how many strings are present
			var stringIndexes:Array = new Array();
			
			for(var i:uint=0; i<nodeArray.length; i++){
				if(nodeArray[i].parent==null && nodeArray[i].child != null){
					//This must be a root node with children.
					stringIndexes.push(i);
				}
			}
			
			if(stringIndexes.length==0){
				//There are no strings.
				return "noStrings";
			}else if(stringIndexes.length==1){
				//There is only one string.
				return nodeArray[stringIndexes[0]].id;
			}else if(stringIndexes.length >1){
				//There are several strings.
				for(i=0; i<nodeArray.length; i++){
					if(nodeArray[i].rootNode){
						activeNode = nodeArray[i].id;
						break;
					}
				}
			}
			
			return activeNode;
		}
/*		public function TEST(e:Event):void{
			trace(getActiveSequence());
		}*/
		
		public function getXML():XML
		{
			return patternXML;
		}
		
		public function setTitleText(nodeID:String, input:String):void
		{
			var node:IPatternNode = getNode(nodeID);
			node.title = input;
			update("setTitleText");
		}
		
		public function setExplainText(nodeID:String, input:String):void{
			var node:IPatternNode = getNode(nodeID);
			node.description = input;
			update("setExplainText");
		}
		
		
		/**
		 * Enables title areas to be set as editable or noneditable. 
		 * @param allowNodeEditing
		 * @return 
		 * 
		 */
		public function set nodeTitleEditing(allowNodeEditing:Boolean):void
		{
			_allowNodeTitleEditing = allowNodeEditing;
		}
		
		public function get nodeTitleEditing():Boolean
		{
			return _allowNodeTitleEditing;
		}
		
		/**
		 * Enables explain areas to be set as editable or noneditable. 
		 * @param allowNodeEditing
		 * @return 
		 * 
		 */
		public function set nodeExplainEditing(allowNodeEditing:Boolean):void
		{
			_allowNodeExplainEditing = allowNodeEditing;
		}
		
		public function get nodeExplainEditing():Boolean
		{
			return _allowNodeExplainEditing;
		}
		
	}
	
	
}