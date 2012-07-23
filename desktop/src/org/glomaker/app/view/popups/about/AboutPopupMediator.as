/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.about
{
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.view.popups.PopupMediator;

	public class AboutPopupMediator extends PopupMediator
	{
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
	
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "AboutPopupMediator";
		
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
				
		public function AboutPopupMediator(viewComponent:AboutPopup)
		{
			super(NAME, viewComponent);
		}


		// ------------------------------------------------------------------
		// PUREMVC INTEGRATION
		// ------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			populateFromProxy();
			
			// Add event listeners
			AboutPopup(viewComponent).aboutCloseButton.visible = true;
			viewRef.aboutCloseButton.addEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			// Remove events listeners
			viewRef.aboutCloseButton.removeEventListener(MouseEvent.CLICK, onCloseClick);
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------

		
		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():AboutPopup
		{
			return viewComponent as AboutPopup;
		}


		/**
		 * Populate the view component from data stored in the model layer. 
		 */
		protected function populateFromProxy():void
		{			
		}
		


		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------

		protected function onCloseClick(evt:MouseEvent):void
		{
			removePopup();
		}
	}
}