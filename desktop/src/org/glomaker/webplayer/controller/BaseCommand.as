/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.controller
{
	import org.glomaker.webplayer.model.ConfigProxy;
	import org.glomaker.webplayer.model.PlayerDataProxy;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Base class to use for BaseCommand classes.
	 * Provides easy access to the proxy classes registered in the framework.
	 *  
	 * @author Nils
	 */
	public class BaseCommand extends SimpleCommand
	{
		
		/**
		 * Retrieve a reference of the ConfigProxy instance currently registered with the framework. 
		 * @return 
		 */
		protected function get configProxy():ConfigProxy
		{
			return facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
		}
		
		/**
		 * Retrieve a reference of the PlayerDataProxy instance currently registered with the framework. 
		 * @return 
		 */
		protected function get playerDataProxy():PlayerDataProxy
		{
			return facade.retrieveProxy(PlayerDataProxy.NAME) as PlayerDataProxy;
		}
		
		
		
		
	}
}