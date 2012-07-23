package org.gloplayer.view.player
{
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.glomaker.shared.player.IPlayerBridge;
	import org.gloplayer.core.Notifications;
	import org.gloplayer.core.mediator.ConfigAwareMediator;
	import org.gloplayer.model.PlayerDataProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Integrates the PlayerView view component with the application. 
	 * @author Nils
	 */
	public class PlayerViewMediator extends ConfigAwareMediator
	{

		/**
		 * PureMVC identifier. 
		 */		
		public static const NAME:String = "PlayerViewMediator";
		

		/**
		 * Constructor
		 * @param mediatorName
		 * @param viewComponent
		 */
		public function PlayerViewMediator(viewComponent:PlayerView)
		{
			super(NAME, viewComponent);
		}
		
		
		/**
		 * PureMVC implementation - carries out initialisation tasks when registered. 
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			var loader:ModuleLoader = PlayerView(viewComponent).playerModuleLoader;
			loader.addEventListener(ModuleEvent.READY, onModuleReady);
			loader.loadModule(configProxy.playerModuleURL);
		}

		/**
		 * PureMVC implementation - carries out cleanup tasks when removed. 
		 */		
		override public function onRemove():void
		{
			super.onRemove();
			
			var loader:ModuleLoader = PlayerView(viewComponent).playerModuleLoader;
			loader.unloadModule();
			loader.removeEventListener(ModuleEvent.READY, onModuleReady);
		}
		
		
		protected function onModuleReady(evt:ModuleEvent):void
		{
			// Open the project file
			this.sendNotification(Notifications.PLAYER_LOADED);
			
		}
		
		override public function listNotificationInterests():Array{
			var list:Array = super.listNotificationInterests();
			list.push(Notifications.DATA_LOADED);	
			return list;		
		}
		
		override public function handleNotification(notification:INotification):void{
			super.handleNotification(notification);
			
			var loader:ModuleLoader = PlayerView(viewComponent).playerModuleLoader;
			var playerBridge:IPlayerBridge = loader.child as IPlayerBridge;
			
			switch(notification.getName()){
				case Notifications.DATA_LOADED:
				
				playerBridge.setGLOStage(projectProxy.stageVO);
				playerBridge.setPageList(projectProxy.settings.pages.source);
				
				break;
			}
		}
		
 		protected function get projectProxy():PlayerDataProxy
		{
			return facade.retrieveProxy(PlayerDataProxy.NAME) as PlayerDataProxy;
		}
	

}
}