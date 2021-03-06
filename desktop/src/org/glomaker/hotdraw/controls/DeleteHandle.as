/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw.controls
{
	import com.hotdraw.CH.ifa.draw.framework.Figure;

	import flash.display.Graphics;
	
	import mx.controls.Image;

	public class DeleteHandle extends FunctionHandle
	{
	
		public function DeleteHandle(owner:Figure,order:int)
		{
			super(owner,"cancel.png",order);
		}
	}
}