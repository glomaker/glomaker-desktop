/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	
	import flash.display.Sprite;
	
	/**
	 * Basic node. Creates the box or whatever basic shape. 
	 * @author USER
	 * 
	 */
	public class Node extends Sprite
	{
		protected var sqrSize:uint;
		protected var colour:uint;		
		protected var extend:int;
		protected var node:Sprite;
		
		// public static const NODE_UP:String = "nodeUp";
		
		/**
		 * Constructor. 
		 * @param sqr
		 * @param c
		 * 
		 */
		public function Node(sqr:uint, c:uint)
		{
						
			sqrSize = sqr;
			colour = c;
			
			var extend:uint = 25;
			var safeArea:Sprite = new Sprite();
			
			safeArea.graphics.beginFill(0, 0);
			safeArea.graphics.drawRect(-extend, -extend, extend*2, extend*2);
			
			addChild(safeArea); 
			
			createNode();
		}
		
		/**
		 * Makes a square by default. Override to amend shape. 
		 * 
		 */
		protected function createNode():void 
		{
			
			node = new Sprite();
			node.name = "node";
			
			node.graphics.beginFill(colour);
			node.graphics.lineStyle(1);
			node.graphics.drawRect(-sqrSize / 2,-sqrSize / 2, sqrSize, sqrSize);
			node.graphics.endFill(); 

			addChild(node);
		}
	}
}