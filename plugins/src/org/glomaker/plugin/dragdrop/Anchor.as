/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.dragdrop
{
	import flash.display.Graphics;
	
	import mx.core.UIComponent;
	
	[Style(name="color", type="uint", format="Color", inherit="yes")]
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]
	[Style(name="backgroundAlpha", type="Number", inherit="no")]
	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]
	
	/**
	 * Renders an anchor for a matching quiz item.
	 * 
	 * @author haykel
	 * 
	 */
	public class Anchor extends UIComponent
	{
		public function Anchor()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var color:Number = getStyle("color");
			var borderColor:Number = getStyle("borderColor");
			var backgroundAlpha:Number = getStyle("backgroundAlpha");
			var backgroundColor:Object = getStyle("backgroundColor");
			
			var g:Graphics = graphics;
			g.clear();
			
			g.beginFill(0xFFFFFF);
			g.drawEllipse(0, 0, unscaledWidth, unscaledHeight);
			g.endFill();
			
			if (backgroundColor != null && backgroundColor != "")
			{
				g.beginFill(uint(backgroundColor), backgroundAlpha);
				g.drawEllipse(0, 0, unscaledWidth, unscaledHeight);
				g.endFill();
			}
			
			g.lineStyle(1, borderColor);
			g.drawEllipse(0, 0, unscaledWidth, unscaledHeight);
			g.lineStyle();
			
			g.beginFill(color);
			g.drawEllipse(unscaledWidth / 4, unscaledHeight / 4, unscaledWidth / 2, unscaledHeight / 2);
			g.endFill();
		}
	}
}