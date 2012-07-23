/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.core
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	
	import mx.core.Application;
	
	import org.glomaker.app.core.mediator.ConfigAwareMediator;
	import org.glomaker.app.model.ConfigProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.view.nav.AppSectionMediator;
	import org.glomaker.app.view.nav.MenuMediator;
	import org.glomaker.app.view.nav.NavBarMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;


	/**
	 * Mediator to integrate the main GLO-Maker application view into the framework.
	 * Handles application-level events and provides shortcut integration for legacy code. 
	 * @author Nils
	 */	
	public class GLOMakerMediator extends ConfigAwareMediator
	{
		
		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * PureMVC identifier. 
		 */		
		public static const NAME:String = "GLOMakerMediator";
		

		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		protected var mainApp:DisplayObject;
		protected var nonMinimisedDisplayState:String; // only for macs
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * Constructor 
		 * @param viewComponent
		 */		
		public function GLOMakerMediator(viewComponent:GLO_v2)
		{
			super(NAME, viewComponent);
			
			// we remove the entire main application from the display list for now
			// that will allow us to initially display a splash-screen in its place
			// the application is added back to the display list when the startup process has completed
			mainApp = appRef.removeChild(appRef.mainAppComponent);
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent property. 
		 * @return 
		 */		
		protected function get appRef():GLO_v2
		{
			return viewComponent as GLO_v2;
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
			appRef.nativeWindow.addEventListener(Event.CLOSING, onWindowClosing);

			// we also trap the 'Invoke' event - used to launch files and called when user clicks on Mac tray icon			
			appRef.nativeApplication.addEventListener(InvokeEvent.INVOKE, onAppInvoke);
			
			// trap the 'displaystatechanging' event so we can restore to the correct normal/maximised state
			// this is only necessary on a mac
			if( NativeApplication.supportsDockIcon )
				appRef.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, onDisplayStateChanging);
		}

		/**
		 * @inheritDoc 
		 */		
		override public function onRemove():void
		{
			// cleanup
			appRef.nativeWindow.removeEventListener(Event.CLOSING, onWindowClosing);
			appRef.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onAppInvoke);
			appRef.nativeWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING, onDisplayStateChanging);
		}
		
		
	 	/**
	 	 * PureMVC callback - list notifications. 
	 	 * @return 
	 	 */		
	 	override public function listNotificationInterests():Array
	 	{
	 		var list:Array = super.listNotificationInterests();
	 	
	 		// startup messages
	 		list.push(Notifications.APP_STARTUP_MESSAGE);
	 		list.push(Notifications.APP_STARTUP_COMPLETE);
	 		
	 		// show/hide application
	 		list.push(Notifications.APP_SHOW_APPLICATION);
	 		list.push(Notifications.APP_HIDE_APPLICATION);
	 	
	 		// update title bar when filename has changed
	 		list.push(ProjectSettingsProxy.FILENAME_UPDATE);
	 		
	 		return list;
	 	}
	 	
	 	
	 	/**
	 	 * PureMVC callback - handle incoming notification.
	 	 * @param notification
	 	 */	 	
	 	override public function handleNotification(notification:INotification):void
	 	{
	 		super.handleNotification(notification);
	 		
	 		
	 		// current use: tie in legacy code with new PureMVC notification system
	 		switch(notification.getName())
	 		{
	 	
	 			case Notifications.APP_STARTUP_MESSAGE:
	 				appRef.statusField.text = notification.getBody() as String;
	 				break;
	 				
	 			case Notifications.APP_STARTUP_COMPLETE:
	 			
	 				appRef.removeChild(appRef.startupStatusPanel);
	 				
	 				// add actual application again
	 				appRef.addChild(mainApp);
	 				
	 				// register child mediators
	 				addChildMediators();
	 				break;
	 		
	 		
	 			case Notifications.APP_SHOW_APPLICATION:
	 				// show the main application component
	 				appRef.mainAppComponent.visible = true;
	 				break;

	 			case Notifications.APP_HIDE_APPLICATION:
	 				// hide the main application component
	 				appRef.mainAppComponent.visible = false;
	 				break;
	 		
	 			case ProjectSettingsProxy.FILENAME_UPDATE:
	 				// update title bar with new filename
	 				updateTitle(notification.getBody() as String);
	 				break;	
	 		}
	 	}
	 	
	 	
		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------
 	
	 	/**
	 	 * Add mediators for the application's child view components. 
	 	 */	 	
	 	protected function addChildMediators():void
	 	{
	 		facade.registerMediator(new NavBarMediator(appRef.appNavBar));
			facade.registerMediator(new AppSectionMediator(appRef.appViewStack));
 			facade.registerMediator(new MenuMediator(appRef.appMenu));
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
	 		if(!cp.defaultAppTitle || cp.defaultAppTitle == "")
	 			cp.defaultAppTitle = appRef.nativeWindow.title;
	 			
	 		// set new title including current filename
	 		var newTitle:String = configProxy.defaultAppTitle;
			
			if(currentFilename && currentFilename != "")
				newTitle +=  " - " + currentFilename;
				
			// apply
			appRef.title = newTitle; 
	 	}
	 	
	 	protected function get projectProxy():ProjectSettingsProxy
	 	{
	 		return facade.retrieveProxy( ProjectSettingsProxy.NAME ) as ProjectSettingsProxy;
	 	}
	 	
	 	
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
 	
	 	/**
	 	 * Event handler - main application window is about to close. 
	 	 * @param evt
	 	 */	 	
	 	protected function onWindowClosing(evt:Event):void
	 	{
	 		// change: if there is no data, we can close immediately
	 		if ( projectProxy.currentPattern == null )
	 			return;
	 		
	 		// stop the actual action from continuing
	 		// we want to present the user with a 'save changes' dialog box instead
	 		evt.preventDefault();
	 		
	 		// if a popup is currently showing, we completely ignore the event
	 		if( Application.application.systemManager.numModalWindows > 0 )
	 			return;
	 		
	 		// trigger the application's specific close action (this will show a 'confirm close' alert)
	 		sendNotification(Notifications.CONTROLS_EXIT);
	 	}
	 	
	 	protected function onAppInvoke(evt:InvokeEvent):void
	 	{
	 		// need to manually restore on a mac
	 		if( NativeApplication.supportsDockIcon && appRef.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED )
	 		{
	 			// might have been maximised or normal before minimising
	 			if(nonMinimisedDisplayState == NativeWindowDisplayState.MAXIMIZED)
	 				appRef.nativeWindow.maximize();
	 			else
	 				appRef.nativeWindow.restore();
	 		}
	 		
	 		// pass on to application
	 		sendNotification(Notifications.APP_INVOKE, evt);
	 	}
	 	
	 	protected function onDisplayStateChanging(evt:NativeWindowDisplayStateEvent):void
	 	{
			// on a mac, need to keep track of whether the app was in normal or maximised mode before minimising
			// otherwise we can't restore back properly
			if( evt.afterDisplayState == NativeWindowDisplayState.MINIMIZED )
				nonMinimisedDisplayState = evt.beforeDisplayState;	 			 		
	 	}
	}
}