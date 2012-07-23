/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.controller.startup
{
	import org.glomaker.webplayer.GloWebPlayer;
	import org.glomaker.webplayer.model.ConfigProxy;
	import org.glomaker.webplayer.model.PlayerDataProxy;
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