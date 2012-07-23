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
	 * Proxy class - stores guidance data and makes it available to the application. 
	 * @author Nils
	 */
	public class GuidanceProxy extends Proxy
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC Identifier 
		 */
		public static const NAME:String = "GuidanceProxy";
		

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------

		public var isGuidanceOn:Boolean = false;
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		public function GuidanceProxy()
		{
			super(NAME);
		}
		
	}
}