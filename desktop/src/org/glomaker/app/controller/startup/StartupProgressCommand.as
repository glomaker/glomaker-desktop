/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.controller.startup
{
	import org.glomaker.app.controller.BaseCommand;
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ComponentPluginProxy;
	import org.glomaker.app.model.PagePluginProxy;
	import org.glomaker.app.model.PatternPluginProxy;
	import org.glomaker.app.model.PluginProxy;
	import org.glomaker.app.model.StagePluginProxy;
	import org.glomaker.app.model.StartupProgressProxy;
	import org.glomaker.common.data.StageVO;
	import org.puremvc.as3.multicore.interfaces.INotification;

	/**
	 * Handles Notifications relating to the application's startup sequence.
	 * Route all such notifications through this command.
	 * The command registers and removes a StartupProgressProxy instance as and when necessary.
	 * Sends a 'APP_STARTUP_COMPLETE' notification when the process has finished. 
	 * @author Nils
	 */	
	public class StartupProgressCommand extends BaseCommand
	{

		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case PluginProxy.DISCOVERING:
					sendStatusMsg(notification.getBody() + " plugin discovered.");
					break;
				
				case PluginProxy.DISCOVERY_COMPLETE:
					handleDiscoveryNotification(notification);
					break;
			}

			// all done?
			if(progressProxy.isStartupComplete)
			{
				removeProgressProxy();
				sendNotification(Notifications.APP_STARTUP_COMPLETE);
			}	
		}
		
		
		protected function handleDiscoveryNotification(notification:INotification):void
		{
			var next:PluginProxy;
			
			switch(notification.getType())
			{
				case ComponentPluginProxy.NAME:
					// components have been auto-discovered
					progressProxy.isComponentDiscoveryComplete = true;
					
					// start discovery of pages
					next = pagePlugins;
					break;
					
				case PagePluginProxy.NAME:
					// pages have been auto-discovered
					progressProxy.isPageDiscoveryComplete = true;
					
					// start discovery of stage definitions
					next = stagePlugins;
					break;
					
				case StagePluginProxy.NAME:
					// stage definitions have been auto-discovered
					progressProxy.isStageDiscoveryComplete = true;
					
					// select first stage [Musbah, 8Dec09, Default Stage, change to third place for Natural Blue,.. this might cause an error if there are not three stages as default]
					project.settings.selectedStage = stagePlugins.getSortedStageList()[2] as StageVO;

					// start discovery of pedagogical patterns
					next = patternPlugins;					
					break;
					
				case PatternPluginProxy.NAME:
					// pattern definitions have been auto-discovered
					progressProxy.isPatternDiscoveryComplete = true;
					
					// this is the end of the discovery process
					break;
			}
			
			// start discovery if there is a next one in line
			if(next)
				next.discover();
		}


		/**
		 * Send a status update to the application. 
		 * @param msg
		 */
		protected function sendStatusMsg(msg:String):void
		{
			sendNotification(Notifications.APP_STARTUP_MESSAGE, msg);
		}


		/**
		 * Unregisters the StartupProgressProxy instance from the application.
		 * Call this method once startup is complete. 
		 */
		protected function removeProgressProxy():void
		{
			facade.removeProxy(StartupProgressProxy.NAME);
		}


		/**
		 * Retrieves the StartupProgressProxy instance registered with the application.
		 * If there isn't one, it creates an instance and registers it. 
		 * @return 
		 */		
		protected function get progressProxy():StartupProgressProxy
		{
			var name:String = StartupProgressProxy.NAME;
			
			// create + register an instance if none exists right now
			if(!facade.hasProxy(name))
			{
				facade.registerProxy(new StartupProgressProxy());
			}
				
			return facade.retrieveProxy(name) as StartupProgressProxy;
		}
		
	}
}