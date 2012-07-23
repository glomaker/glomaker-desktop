/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data
{
	import org.glomaker.shared.component.interfaces.ISlideshowStatusObject;
	
	/**
	 * Encapsulates current slideshow / playback status.
	 * Used by the component interface to notify components of next/previous/page select actions.
	**/
	public class SlideshowStatusVO implements ISlideshowStatusObject
	{
		/**
		 * Total number of pages.
		**/
		private var _pageCount:uint;
		
		/**
		 * Index of currently selected page.
		 * Note that indexing starts at 0.
		*/
		private var _currentPage:int;
		
		
		// *********************
		// CONSTRUCTOR
		// *********************
		
		
		/**
		 * Constructor 
		 * @param pageCount
		 * @param currentPage
		 * 
		 */		
		public function SlideshowStatusVO(pageCount:uint = 0, currentPage:int = -1)
		{
			_pageCount = pageCount;
			_currentPage = currentPage;
		}


		// *********************
		// GETTER / SETTERS
		// These also implement the IStatusUpdate interface
		// *********************
		
		public function set pageCount(value:uint):void
		{
			_pageCount = value;
		}
		public function get pageCount():uint
		{
			return _pageCount;
		}
		
		public function set currentPage(value:int):void
		{
			_currentPage = value;
		}
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		
		/**
		 * Is a page currently selected? 
		 * @return 
		 */		
		public function get isPageSelected():Boolean
		{
			return currentPage != -1;
		}
		
		/**
		 * Is the first page selected?
		**/
		public function get isFirst():Boolean
		{
			return currentPage == 0;
		}
		
		/**
		 * Is the last page selected?
		**/
		public function get isLast():Boolean
		{
			return (pageCount > 0) && (currentPage == pageCount - 1);
		}
	}
}