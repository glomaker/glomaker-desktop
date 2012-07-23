/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw.controls
{
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	import com.hotdraw.CH.ifa.draw.standard.AbstractHandle;
	import com.hotdraw.java.awt.geom._Point;
	import com.hotdraw.java.awt.geom._Rectangle;
	
	import flash.display.Graphics;
	
	import mx.controls.Image;

    // This class used by the GloSelectionTool to add functions to the Figure
    // such as delete, move up/down etc
	public class FunctionHandle extends AbstractHandle
	{
			private var imgSize:int = 16; // default size of the icons
		    private var margin:int=3; // margin between the icon and the figure
		    private var order:int; // function handles are located in the x axis in according to their order (first 0, then 1, etc)
		    private var path:String = "org/glomaker/hotdraw/controls/";

		public function FunctionHandle(owner:Figure, source:String, ord:int =0)
		{
			super(owner);
			// Attach an icon to the uicomponent of the handler
			var img:Image = new Image();
			img.source = path+source;
			img.width= imgSize;
			img.height = imgSize;
			this.addChild(img);
			order = ord;
			
		}
		
    /**
     * Gets the display box of the handle.
     */
    override public function displayBox():_Rectangle {
        var p:_Point= locate();
        return new _Rectangle(p.x,p.y,imgSize, imgSize);;
    }
		
      /**
     * Locates the handle on the figure by forwarding the request
     * to its figure.
     */
    override public function locate():_Point {
    	var db:_Rectangle = ownerFigure().displayBox();
    	return new _Point(db.x + margin+ (imgSize + margin) * order ,db.y - (imgSize + margin) );
    }
        
    override public function draw(g:Graphics):void{
    }
		
	}
}