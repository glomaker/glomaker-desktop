/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.controller.startup
{
	import org.glomaker.webplayer.GloWebPlayer;
	import org.glomaker.webplayer.controller.BaseCommand;
	import org.glomaker.webplayer.core.GLOPlayerMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Creates Mediator instances for the application and registers them with the facade. 
	 * @author Nils
	 */	
	public class InitialiseMediatorsCommand extends BaseCommand
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
			
			// mediator for the main application
			// all other mediators are added by this class when startup has completed
			facade.registerMediator(new GLOPlayerMediator(appRef));
			
			// load in data
			playerDataProxy.url = configProxy.projectPath;
		}
		
	}
}