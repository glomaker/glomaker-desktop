/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw.controls
{
	import com.hotdraw.CH.ifa.draw.framework.Figure;

	public class EditHandle extends FunctionHandle
	{
		public function EditHandle(owner:Figure,order:int)
		{
		  super(owner,"pencil.png",order);
		}
		
	}
}