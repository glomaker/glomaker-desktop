package org.gloplayer.core
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.gloplayer.core.mediator.ConfigAwareMediator;
	import org.gloplayer.model.ConfigProxy;
	

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
	 	 * Update application title to include current filename. 
	 	 * @param currentFilename
	 	 */ 			 		 		 	
	 	protected function updateTitle( currentFilename:String ):void
	 	{
	 		// alias for efficient access
	 		var cp:ConfigProxy = configProxy;
	 		
	 		// the application's initial title is stored in the config proxy first time round
/* 	 		if(!cp.defaultAppTitle || cp.defaultAppTitle == "")
	 			cp.defaultAppTitle = appRef.nativeWindow.title;
	 			
	 		// set new title including current filename
			appRef.title = configProxy.defaultAppTitle + " - " + currentFilename;
 */	 	}
	 	
	 	
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
 	
	 	/**
	 	 * Event handler - main application window is about to close. 
	 	 * @param evt
	 	 */	 	
	 	 
	 	protected function onWindowClosing(evt:Event):void
	 	{
	 		// stop the actual action from continuing
	 		// we want to present the user with a 'save changes' dialog box instead
	 		evt.preventDefault();
	 		
	 		// trigger the application's specific close action
	 		// sendNotification(Notifications.CONTROLS_EXIT);
	 	}
		
		

		
	}
}