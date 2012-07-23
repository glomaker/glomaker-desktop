/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.start
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.view.popups.PopupMediator;


	/**
	 * Integrates the StartChoicesPopup view component with the application. 
	 * @author Nils
	 */
	public class StartChoicesPopupMediator extends PopupMediator
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC Identifier 
		 */		
		public static const NAME:String = "StartChoicesPopupMediator";


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 * @param viewComponent
		 */		
		public function StartChoicesPopupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			if(!(viewComponent is StartChoicesPopup))
				throw new Error("Mediator expects a StartChoicesPopup viewcomponent.");
		}


		// ------------------------------------------------------------------
		// PureMVC METHOD OVERRIDES
		// ------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			popup.createButton.addEventListener(MouseEvent.CLICK, onCreateClick);
			popup.openButton.addEventListener(MouseEvent.CLICK, onOpenClick);
			popup.firstTimeButton.addEventListener(MouseEvent.CLICK, onHelpClick);

		}
		
		override public function onRemove():void
		{
			super.onRemove();
			popup.createButton.removeEventListener(MouseEvent.CLICK, onCreateClick);
			popup.openButton.removeEventListener(MouseEvent.CLICK, onOpenClick);
			popup.firstTimeButton.removeEventListener(MouseEvent.CLICK, onHelpClick);
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------

		/**
		 * Returns a typed reference to the viewComponent property. 
		 * @return 
		 */		
		protected function get popup():StartChoicesPopup
		{
			return viewComponent as StartChoicesPopup;
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		
		
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		/**
		 * 'Create New Project' link clicked. 
		 * @param evt
		 */		
		protected function onCreateClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.CONTROLS_NEW);
			removePopup();
		}

		/**
		 * 'Open Existing Project' link clicked. 
		 * @param evt
		 */		
		protected function onOpenClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.CONTROLS_OPEN);
			removePopup();
		}
		
		/**
		 * 'Help' button was clicked. 
		 * @param evt
		 */		
		protected function onHelpClick(evt:MouseEvent):void
		{
			navigateToURL( new URLRequest(configProxy.helpSiteURL) );
		}

		
	}
}