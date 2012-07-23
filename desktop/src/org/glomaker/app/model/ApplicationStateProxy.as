/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.model
{
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class ApplicationStateProxy extends Proxy
	{


		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC identifier. 
		 */		
		public static const NAME:String = "ApplicationStateProxy";
		
		
		/**
		 * Notification sent when the selected section has changed.
		 * Body: section identifier (:int) - taken from the ApplicationStateProxy static constant values. 
		 */		
		public static const SECTION_CHANGE_NOTIFICATION:String = "ApplicationStateProxy.SectionChange";
		
		
		// application section identifiers
		public static const SECTION_PATTERNMAKER:int = 1;
		public static const SECTION_EDITOR:int = 2;
		public static const SECTION_PLAYER:int = 3;


		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * Stores the section (patternmaker, design, preview) currently selected in the application.
		 * Use SECTION_ static variables to obtain the correct values.
		 * Initially (and importantly), the Patternmaker section is selected, since it is the first element in the application viewstack.
		 */		
		protected var _selectedSection:int = SECTION_PATTERNMAKER;
		

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		public function ApplicationStateProxy()
		{
			super(NAME);
		}



		// ------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------
		
		
		public function set selectedSection(value:int):void
		{
			if(value != _selectedSection)
			{
				_selectedSection = value;
				sendNotification( SECTION_CHANGE_NOTIFICATION, _selectedSection );
			}
		}
		
		public function get selectedSection():int
		{
			return _selectedSection;
		}
		
		
		
		
	}
}