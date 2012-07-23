/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import flash.utils.Dictionary;
	
	import org.glomaker.interfaces.pattern.IPatternNode;
	

	/**
	 * Helper class to provide easy linked-list  
	 * @author admin
	 * 
	 */
	public class LinkedPatternNode
	{


		public static function createLinkedList(nodeList:Array):LinkedPatternNode
		{
			// lookup table
			var dict:Dictionary = new Dictionary();
			var node:IPatternNode;
			var rootNode:IPatternNode;
			
			for each(node in nodeList)
			{
				dict[node.id] = node;
				
				if(node.isRoot)
					rootNode = node;
			}
			
			// no root node - error
			if(!rootNode)
				throw new Error("No root node found in node sequence.");
				
			// create linked list
			var root:LinkedPatternNode = new LinkedPatternNode(rootNode);
			
			var currentNode:IPatternNode = rootNode;
			var currentLink:LinkedPatternNode = root;
			
			while(currentNode)
			{
				currentNode = dict[currentNode.childId] as IPatternNode;
				
				if(currentNode)
				{
					currentLink.child = new LinkedPatternNode(currentNode);
					currentLink.child.parent = currentLink;
				
					// next in line
					currentLink = currentLink.child;
				}
			}
			
			// done - we simply return the root of the linked list
			return root;
		}


		private var _node:IPatternNode;
		private var _child:LinkedPatternNode;
		private var _parent:LinkedPatternNode;
		
		public function LinkedPatternNode(node:IPatternNode)
		{
			_node = node;
		}
		
		public function get node():IPatternNode
		{
			return _node;
		}
		public function get parent():LinkedPatternNode
		{
			return _parent;
		}
		public function set parent(value:LinkedPatternNode):void
		{
			_parent = value;
		}
		
		public function get child():LinkedPatternNode
		{
			return _child;
		}
		public function set child(value:LinkedPatternNode):void
		{
			_child = value;
		}

	}
}