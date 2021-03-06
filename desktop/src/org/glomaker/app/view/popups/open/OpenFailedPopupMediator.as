/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.open
{
	import flash.events.Event;
	
	import mx.containers.TitleWindow;
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.view.popups.PopupMediator;


	/**
	 * Integrates the OpenFailedPopup view component with the application. 
	 * @author Nils
	 */
	public class OpenFailedPopupMediator extends PopupMediator
	{
		
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC Identifier 
		 */
		public static const NAME:String = "OpenFailedPopupMediator";
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 * @param viewComponent
		 */		
		public function OpenFailedPopupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}


		// ------------------------------------------------------------------
		// PureMVC METHOD OVERRIDES
		// ------------------------------------------------------------------

		override public function onRegister():void
		{
			super.onRegister();
			
			// custom event broadcast when the 'close' button is clicked
			popup.addEventListener(Event.CLOSE, onCloseClick);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			popup.removeEventListener(Event.CLOSE, onCloseClick);
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent property. 
		 * @return 
		 */		
		protected function get popup():TitleWindow
		{
			return viewComponent as TitleWindow;
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		
		protected function hasProject():Boolean
		{
			var proxy:ProjectSettingsProxy = facade.retrieveProxy( ProjectSettingsProxy.NAME ) as ProjectSettingsProxy;
			return Boolean(proxy.currentPattern);
		}


		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		
		/**
		 * Event handler - CLOSE button clicked 
		 * @param evt
		 */		
		protected function onCloseClick(evt:Event):void
		{
			// decide what to do next
			// if a project is already loaded, we just show the application again (it's hidden by the file open process)
			// otherwise, we are still at the start of the application, so show the startup wizard
			hasProject() ? sendNotification( Notifications.APP_SHOW_APPLICATION ) : sendNotification( Notifications.APP_SHOW_STARTUP_WIZARD );
			
			// remove popup and the mediator instance - they are no longer required
			removePopup();
		}

	}
}