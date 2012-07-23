/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.component.interfaces
{
	/**
	 * Interface to be implemented by components that wish to be able to update slideshow status (next/previous/etc)
	**/
	public interface ISlideshowNavigator
	{
		
		/**
		 * Attaches a slideshow controller instance.
		 * The component can use this instance to navigate inside the current slideshow.
		**/
		function attachSlideshowController(controller:ISlideshowNavigationController):void;
		
		/**
		 * Removes the slideshow controller.
		 * Cleanup method called when a component instance is destroyed.
		**/
		function detachSlideshowController():void;
		
	}
}