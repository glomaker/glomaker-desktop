/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;


	/**
	 * Stores references to currently selected page / component. 
	 * @author Nils
	 */
	public class SelectionProxy extends Proxy
	{
		
		// *********** STATIC PROPERTIES

		/**
		 * PureMVC identifier. 
		 */		
		public static const NAME:String = "SelectionProxy";


		/**
		 * PureMVC Notification name
		 * Body: index of the now selected page (:int) 
		 */
		public static const SELECTED_PAGE_UPDATED:String = "SelectionProxy.SelectedPageUpdated";
		
		
		
		// *********** INSTANCE PROPERTIES
		
		private var _selectedPageIndex:int = -1;
		private var _previousPageIndex:int = -1;
		
		
		/**
		 * Constructor 
		 * @param proxyName
		 * @param data
		 */		
		public function SelectionProxy()
		{
			super(NAME);
			
		}
		
		/**
		 * Retrieve a reference of the ProjectSettingsProxy instance currently registered with the framework. 
		 * @return 
		 */		
		 
		protected function get project():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}

		// *********** GETTER / SETTERS
		
		
		/**
		 * Resets page index value to 0 and clears the 'selectedPageIndex' property.
		 * No Notifications are sent by this method..
		 */		
		public function reset():void
		{
			// manipulate values directly to avoid Notifications being sent
			_previousPageIndex = -1;
			_selectedPageIndex = 0;
/* 			if(project.settings.loadedPageIndex>0)
				_selectedPageIndex = project.settings.loadedPageIndex;
 */		}
		
		/**
		 * Get/set index of currently selected page.
		 * This is relative to the list of pages in the current project.
		**/
		public function set pageIndex(value:int):void
		{
			if(_selectedPageIndex != value)
			{
				_previousPageIndex = _selectedPageIndex;
				_selectedPageIndex = value;
				sendNotification(SELECTED_PAGE_UPDATED, _selectedPageIndex);
			}
		}
		
		public function get pageIndex():int
		{

			return _selectedPageIndex;
		}
		
		public function get previousPageIndex():int
		{
			return _previousPageIndex;
		}
		
	}
}