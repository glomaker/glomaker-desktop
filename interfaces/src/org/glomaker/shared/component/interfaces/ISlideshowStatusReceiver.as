/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.component.interfaces
{
	
	/**
	 * Interface to be implemented by components that wish to receive slideshow status updates.
	**/
	public interface ISlideshowStatusReceiver
	{
		
		function receiveUpdate(info:ISlideshowStatusObject):void;
		
	}
}