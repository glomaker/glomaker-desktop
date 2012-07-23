/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.startup
{
	import org.glomaker.app.model.ApplicationStateProxy;
	import org.glomaker.app.model.ComponentPluginProxy;
	import org.glomaker.app.model.ConfigProxy;
	import org.glomaker.app.model.GuidanceProxy;
	import org.glomaker.app.model.HotDrawProxy;
	import org.glomaker.app.model.PagePluginProxy;
	import org.glomaker.app.model.PatternPluginProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.app.model.SharedMemoryProxy;
	import org.glomaker.app.model.StagePluginProxy;
	import org.glomaker.app.model.StateProxy;
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
			var appRef:GLO_v2 = notification.getBody() as GLO_v2;
			
			// test correct body
			if(!appRef)
				throw new Error("Notification body must be the main application instance.");

			// instantiate and register proxies			
			facade.registerProxy(new ConfigProxy());
			facade.registerProxy(new ApplicationStateProxy());
			facade.registerProxy(new StateProxy());
			facade.registerProxy(new ProjectSettingsProxy());
			facade.registerProxy(new SelectionProxy());
			facade.registerProxy(new PagePluginProxy());
			facade.registerProxy(new ComponentPluginProxy());
			facade.registerProxy(new StagePluginProxy());
			facade.registerProxy(new PatternPluginProxy());
			facade.registerProxy(new SharedMemoryProxy());
			facade.registerProxy(new HotDrawProxy());			
			facade.registerProxy(new GuidanceProxy());			
		}
		
	}
}