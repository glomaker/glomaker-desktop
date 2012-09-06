/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.journey
{
	import flash.events.MouseEvent;
	
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.view.popups.PopupMediator;
	import org.glomaker.app.view.popups.journey.JourneySettingsPopup;
	import org.glomaker.common.data.JourneySettingsVO;

	
	/**
	 * Integrates the JourneySettingsPopup view component into the application.
	 * 
	 * @author Haykel
	 */	
	public class JourneySettingsPopupMediator extends PopupMediator
	{
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
	
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "JourneySettingsPopupMediator";
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * Journey settings to work on.
		 */
		protected var settings:JourneySettingsVO;

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
				
		public function JourneySettingsPopupMediator(viewComponent:JourneySettingsPopup)
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
			viewRef.okButton.addEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			// Remove events listeners
			viewRef.okButton.removeEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
		}

		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------

		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():JourneySettingsPopup
		{
			return viewComponent as JourneySettingsPopup;
		}

		/**
		 * Populate the view component from data stored in the model layer. 
		 */
		protected function populateFromProxy():void
		{
			var projectProxy:ProjectSettingsProxy = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy);
			settings = projectProxy.settings.journey ? projectProxy.settings.journey : new JourneySettingsVO();
			
			viewRef.nameInput.text = settings.name;
			viewRef.locationInput.text = settings.location;
			viewRef.indexInput.value = settings.index;
		}
		
		/**
		 * Update settings data from view component.
		 */
		protected function updateSettingsFromView():void
		{
			settings.name = viewRef.nameInput.text;
			settings.location = viewRef.locationInput.text;
			settings.index = viewRef.indexInput.value;
		}
		
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------

		protected function onOKClick(evt:MouseEvent):void
		{
			var projectProxy:ProjectSettingsProxy = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy);
			projectProxy.settings.journey = settings;
			updateSettingsFromView();
			removePopup();
		}
		
		protected function onCancelClick(evt:MouseEvent):void
		{
			removePopup();
		}
		
	}
}