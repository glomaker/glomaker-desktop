package org.gloplayer.controller.startup
{
	import org.gloplayer.model.ConfigProxy;
	import org.gloplayer.model.PlayerDataProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	
	/**
	 * Creates Proxy instances for the application and registers them with the facade. 
	 * @author Nils
	 */	
	public class InitialiseProxiesCommand extends SimpleCommand
	{

		/**
		 * @inheritDoc 
		 * @param notification Expects the main application instance in the Body.
		 */
		override public function execute(notification:INotification):void
		{
			var appRef:GloWebPlayer = notification.getBody() as GloWebPlayer;
			
			// test correct body
			if(!appRef)
				throw new Error("Notification body must be the main application instance.");

			// instantiate and register proxies			
			facade.registerProxy(new ConfigProxy());
			facade.registerProxy(new PlayerDataProxy());
		}
		
	}
}