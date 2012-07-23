/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.webplayer.core
{
	import flash.display.DisplayObject;
	
	import org.glomaker.webplayer.GloWebPlayer;
	import org.glomaker.webplayer.core.mediator.ConfigAwareMediator;
	import org.glomaker.webplayer.model.PlayerDataProxy;
	import org.puremvc.as3.multicore.interfaces.INotification;
	

	public class GLOPlayerMediator extends ConfigAwareMediator
	{
		
		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * PureMVC identifier. 
		 */		
		public static const NAME:String = "GLOPlayerMediator";
		

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		protected var mainApp:DisplayObject;
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		

		/**
		 * Constructor 
		 * @param viewComponent
		 */		
		public function GLOPlayerMediator(viewComponent:GloWebPlayer)
		{
			super(NAME, viewComponent);
			
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent property. 
		 * @return 
		 */		
		protected function get appRef():GloWebPlayer
		{
			return viewComponent as GloWebPlayer;
		}
		
		
		// ------------------------------------------------------------------
		// PureMVC INTEGRATION
		// ------------------------------------------------------------------
		
		/**
		 * @inheritDoc 
		 */		
		override public function onRegister():void
		{
			// we trap the 'window closing' event so we can prompt the user to save data
			//appRef.nativeWindow.addEventListener(Event.CLOSING, onWindowClosing);	
		}

		/**
		 * @inheritDoc 
		 */		
		override public function onRemove():void
		{
			// cleanup
			//appRef.nativeWindow.removeEventListener(Event.CLOSING, onWindowClosing);
		}
		
	 	
		/**
		 * @inheritDoc 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			list.push(Notifications.DATA_LOADED);	
			return list;		
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			
			switch(notification.getName())
			{
				case Notifications.DATA_LOADED:
				
					var module:PlayerModule = appRef.playerView;
					
					module.width = projectProxy.settings.stageWidth;
					module.height = projectProxy.settings.stageHeight;
					module.setBackgroundColour(projectProxy.settings.stageColour);
					
					module.setGLOStage(projectProxy.stageVO);
					module.setPageList(projectProxy.settings.pages.source);
					
					module.visible = true;
					
			
					break;
			}
		}
		
 		protected function get projectProxy():PlayerDataProxy
		{
			return facade.retrieveProxy(PlayerDataProxy.NAME) as PlayerDataProxy;
		}

	 	
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
 	
		
		

		
	}
}