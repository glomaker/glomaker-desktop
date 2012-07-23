/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.components
{
	import flash.geom.Rectangle;
	import mx.containers.Box;


	/**
	 * Extends the mx:Box component by applying a scrollRect to its entire area.
	 * Results in content being clipped properly when Box is resized. 
	 * @author Nils
	 */
	public class ScrollRectBox extends Box
	{
		override public function setActualSize(w:Number, h:Number):void
		{
			super.setActualSize(w, h);
			scrollRect = new Rectangle(0, 0, w, h);
		}
	}
}