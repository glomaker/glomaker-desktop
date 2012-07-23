/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.export
{
	import flash.events.Event;
	
	import mx.containers.TitleWindow;
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.view.popups.PopupMediator;


	/**
	 * Integrates the ExportFailedPopup and ExportSuccessPopup view component with the application. 
	 * @author Nils
	 */
	public class ExportResultPopupMediator extends PopupMediator
	{
		
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC Identifier 
		 */
		public static const NAME:String = "ExportResultPopupMediator";
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 * @param viewComponent
		 */		
		public function ExportResultPopupMediator(viewComponent:Object)
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
		

		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		
		/**
		 * Event handler - CLOSE button clicked 
		 * @param evt
		 */		
		protected function onCloseClick(evt:Event):void
		{
			// remove popup and the mediator instance - they are no longer required
			removePopup();
		}

	}
}