package org.gloplayer.core.mediator
{
	import org.gloplayer.model.ConfigProxy;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;


	/**
	 * Defines a base-class for Mediators that require access to the ConfigProxy.
	 * Provides a 'configProxy' getter for easy access.
	 * Due to the application's startup sequence, the config proxy's data will always be available by the time mediators are registered.
	 *  
	 * @author Nils
	 */
	public class ConfigAwareMediator extends Mediator
	{
		
		/**
		 * Constructor 
		 * @param mediatorName
		 * @param viewComponent
		 */		
		public function ConfigAwareMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		/**
		 * Retrieve a reference to the ConfigProxy instance currently registered with the application. 
		 * @return 
		 */		
		protected function get configProxy():ConfigProxy
		{
			return facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
		}
		
	}
}