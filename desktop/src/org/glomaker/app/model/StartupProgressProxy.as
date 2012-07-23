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
	 * Stores state information relating to the startup process.
	 * Update flags when different parts have complete and call 'isStartupComplete()' to see whether all processes have completed.
	 * Note: The proxy instance should be removed after the startup process has finished.
	 * Note: The built-in data object is not used by this Proxy.
	 *  
	 * @author Nils
	 */
	public class StartupProgressProxy extends Proxy
	{
		
		/**
		 * PureMVC identifier 
		 */		
		public static const NAME:String = "StartupProgressProxy";
		
		
		/**
		 * State flags
		 * Declared as public for easy access.
		**/
		
		public var isComponentDiscoveryComplete:Boolean = false;
		public var isPageDiscoveryComplete:Boolean = false;
		public var isStageDiscoveryComplete:Boolean = false;
		public var isPatternDiscoveryComplete:Boolean = false;

		
		/**
		 * Constructor 
		 */		
		public function StartupProgressProxy()
		{
			super(NAME);
		}
		
		/**
		 * Has the entire startup process completed? 
		 * @return 
		 */		
		public function get isStartupComplete():Boolean
		{
			var complete:Boolean = true;
			complete = complete && isComponentDiscoveryComplete;
			complete = complete && isPageDiscoveryComplete;
			complete = complete && isStageDiscoveryComplete;
			complete = complete && isPatternDiscoveryComplete;
			
			return complete;
		}
		
	}
}