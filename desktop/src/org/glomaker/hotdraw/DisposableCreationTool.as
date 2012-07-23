/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw
{
	import com.hotdraw.CH.ifa.draw.framework.DrawingView;
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	import com.hotdraw.CH.ifa.draw.standard.CreationTool;
	
	import flash.events.MouseEvent;


// This class is intended to be used to create a Figure once!

	public class DisposableCreationTool extends CreationTool
	{
		public function DisposableCreationTool(view:DrawingView, prototype:Figure=null)
		{
			super(view, prototype);
		}
		
	/**
     * Creates a new figure by cloning the prototype.
     */
      override protected function createFigure():Figure {
        return fPrototype as Figure;
    }
    
    // Select the newly created Figure
      override public function mouseUp(e:MouseEvent, x:int, y:int):void {
      	 var fcFigure:Figure = this.fCreatedFigure;
      	super.mouseUp(e,x,y);
      	view().addToSelection(fcFigure);      	
    }
		
	}
}