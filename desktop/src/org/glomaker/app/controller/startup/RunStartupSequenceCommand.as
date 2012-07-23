/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.startup
{
	import org.glomaker.app.controller.BaseCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Runs the initial startup sequence (loading content, etc).
	 * Run after Proxies / Mediators have been registered. 
	 * @author Nils
	 */	
	public class RunStartupSequenceCommand extends BaseCommand
	{
		
		/**
		 * @inheritDoc 
		 * @param notification Expects the main application instance in the Body.
		 */
		override public function execute(notification:INotification):void
		{
			var appRef:GLO_v2 = notification.getBody() as GLO_v2;
			
			// test correct body
			if(!appRef)
				throw new Error("Notification body must be the main application instance.");

			// start plugin discovery
			componentPlugins.discover();			
		}
		
	}
}