/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.core
{
	import mx.core.Application;
	
	import org.glomaker.webplayer.controller.startup.AppStartupMacroCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	 
	/**
	 * PureMVC Facade implementation for GLO-Player
	 * 
	 * Implements the Singleton interface.
	 *  
	 * @author Musbah
	 */
	
	public class GLOPlayerFacade extends Facade
	{
		public function GLOPlayerFacade(key:String)
		{
			super(key);
		}
		
		/**
		 * Return multiton instance. 
		 * @return 
		 */
		public static function getInstance(key:String):GLOPlayerFacade
		{
			if(!hasCore(key))
			{
				instanceMap[key] = new GLOPlayerFacade(key);
			}
			
			return instanceMap[key] as GLOPlayerFacade;
		}
		
		/**
		 * Application startup function.
		 * @param appRef Reference to the main application instance.
		 */
		public static function start(appKey:String, appRef:Application):void
		{
			getInstance(appKey).sendNotification(Notifications.APP_START, appRef);
		}
		
			override protected function initializeController():void
		{
			super.initializeController();
			
			// startup command
			// Note: No Mediators registered at this stage
			registerCommand(Notifications.APP_START, AppStartupMacroCommand);
		
		}
		
		
	}
}