package org.gloplayer.controller
{
	import org.gloplayer.model.ConfigProxy;
	import org.gloplayer.model.PlayerDataProxy;
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