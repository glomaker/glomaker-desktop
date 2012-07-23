/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.player
{
	import mx.controls.Alert;
	import mx.events.ModuleEvent;
	import mx.modules.ModuleLoader;
	
	import org.glomaker.app.core.mediator.ConfigAwareMediator;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.shared.player.IPlayerBridge;


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
		public function PlayerViewMediator(mediatorName:String, viewComponent:PlayerView)
		{
			super(mediatorName, viewComponent);
		}
		
		
		/**
		 * PureMVC implementation - carries out initialisation tasks when registered. 
		 */
		override public function onRegister():void
		{
			super.onRegister();
			
			// size the player module
			loader.width = projectProxy.settings.stageWidth;
			loader.height = projectProxy.settings.stageHeight;			

			// pass data along if the module is already available
			if(playerBridge)
			{
				setPlayerData();
				playerBridge.init();			

			}else{
				loader.addEventListener(ModuleEvent.READY, onModuleReady);
				loader.loadModule(configProxy.playerModuleURL);
			}
		}

		/**
		 * PureMVC implementation - carries out cleanup tasks when removed. 
		 */		
		override public function onRemove():void
		{
			super.onRemove();
			playerBridge.destroy();
			loader.removeEventListener(ModuleEvent.READY, onModuleReady);
		}
		
		
		/**
		 * Passes data from the proxy to the player module.
		 * Assumes _playerBridge is defined. 
		 */		
		protected function setPlayerData():void
		{
			// alias to avoid repeated getter calls
			var bridge:IPlayerBridge = playerBridge;
			
			bridge.setBackgroundColour(projectProxy.settings.stageColour);
			bridge.setGLOStage(projectProxy.settings.selectedStage);
			bridge.setStartPageIndex(projectProxy.settings.loadedPageIndex);
			bridge.setPageList(projectProxy.settings.pages.source);
			
		}
		
		
		/**
		 * Getter for the ProjectSettingsProxy. 
		 * @return 
		 */		
		protected function get projectProxy():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}
		
		/**
		 * Getter for the view's ModuleLoader instance. 
		 * @return 
		 */		
		protected function get loader():ModuleLoader
		{
			return PlayerView(viewComponent).playerModuleLoader;
		}
		
		/**
		 * Typed getter for the actual player module. 
		 * @return 
		 */
		protected function get playerBridge():IPlayerBridge
		{
			if(loader.child)
				return loader.child as IPlayerBridge;
				
			return null;
		}
		
		/**
		 * Event listener - player module has loaded. 
		 * @param evt
		 */		
		protected function onModuleReady(evt:ModuleEvent):void
		{ 
			loader.removeEventListener(ModuleEvent.READY, onModuleReady);
			
			// pass data to it if currently registered with the facade
			// otherwise this will happen in the next 'onRegister' call
			if(facade)
				setPlayerData();
		}
		
		
	}
}