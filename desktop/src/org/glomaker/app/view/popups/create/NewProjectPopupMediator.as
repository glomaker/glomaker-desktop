/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.create
{
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.PatternPluginProxy;
	import org.glomaker.app.view.popups.PopupMediator;


	/**
	 * Integrates the NewProjectPopup view component with the application. 
	 * @author Nils
	 */
	public class NewProjectPopupMediator extends PopupMediator
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
		public function NewProjectPopupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			if(!(viewComponent is NewProjectPopup))
				throw new Error("Mediator expects a NewProjectPopup viewcomponent.");
		}


		// ------------------------------------------------------------------
		// PureMVC METHOD OVERRIDES
		// ------------------------------------------------------------------

		override public function onRegister():void
		{
			super.onRegister();
			popup.okButton.addEventListener(MouseEvent.CLICK, onOKClick);
			popup.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
			popup.patternList.addEventListener(MouseEvent.DOUBLE_CLICK, onOKClick);
			
			var listData:Array = patternPlugins.getSortedPatternList();
			popup.patternList.dataProvider = listData;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			popup.okButton.removeEventListener(MouseEvent.CLICK, onOKClick);
			popup.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
			popup.patternList.removeEventListener(MouseEvent.DOUBLE_CLICK, onOKClick);
			popup.patternList.dataProvider = null;
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent property. 
		 * @return 
		 */		
		protected function get popup():NewProjectPopup
		{
			return viewComponent as NewProjectPopup;
		}

		/**
		 * Returns the PatternPluginProxy instance currently registered with the facade.
		 * Call in/after onRegister(). 
		 * @return 
		 */		
		protected function get patternPlugins():PatternPluginProxy
		{
			return facade.retrieveProxy(PatternPluginProxy.NAME) as PatternPluginProxy;
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		
		/**
		 * Event handler - OK button clicked 
		 * @param evt
		 */		
		protected function onOKClick(evt:MouseEvent):void
		{
			// get the selected pattern
			var pattern:Object = popup.patternList.selectedItem;
			
			// notify the application
			sendNotification(Notifications.CREATE_NEW_PATTERNSELECT, pattern);
			
			// remove popup and the mediator instance - they are no longer required
			removePopup();
		}
		
		/**
		 * Event handler - Cancel button clicked 
		 * @param evt
		 */		
		protected function onCancelClick(evt:MouseEvent):void
		{
			// notify the application
			sendNotification(Notifications.CREATE_NEW_CANCELLED);

			// remove popup and the mediator instance - they are no longer required
			removePopup();
		}
		
	}
}