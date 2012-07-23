/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	import flash.display.Sprite;
	
	public class RootNode extends Node
	{
		public function RootNode(sqr:uint, c:uint)
		{
			super(sqr, c);
		}
		
		override protected function createNode():void
		{
			var lowerConnector:Sprite = new Sprite();
			
			lowerConnector.name = "lowerConnector";
			lowerConnector.graphics.beginFill(0x000000);
			lowerConnector.graphics.drawRect(-sqrSize / 2, (sqrSize / 2) - 4, sqrSize, 4);
			lowerConnector.graphics.endFill();

			lowerConnector.graphics.beginFill(0x000000);
			lowerConnector.graphics.drawCircle(0, sqrSize / 2, 4);
			lowerConnector.graphics.endFill();
			lowerConnector.buttonMode = true;
			
			addChild(lowerConnector);
			
			
			node = new Sprite();
			node.name = "rootNode";
			node.graphics.beginFill(colour);
			node.graphics.lineStyle(1);
			node.graphics.drawCircle(-sqrSize / 2, -sqrSize / 2, sqrSize / 2);
			node.graphics.endFill();

			addChild(node);
		}
	}
}