package org.gloplayer.core
{
	import mx.core.Application;
	
	import org.gloplayer.controller.open.LoadDataCommand;
	import org.gloplayer.controller.startup.AppStartupMacroCommand;
	
	 
	/**
	 * PureMVC Facade implementation for GLO-Player
	 * 
	 * Implements the Singleton interface.
	 *  
	 * @author Musbah
	 */
	
	public class GLOPlayerFacade extends SwitchDebugFacade
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
			registerCommand(Notifications.PLAYER_LOADED, LoadDataCommand);
		
		}
		
		
	}
}