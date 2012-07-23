/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.editor
{
	import flash.events.Event;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.GuidanceProxy;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;


	/**
	 * Integrates the GuidanceControls view component with the application. 
	 * @author Nils
	 */
	public class GuidanceControlsMediator extends Mediator
	{
		
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC Identifier 
		 */
		public static const NAME:String = "GuidanceControlsMediator";
		
		/**
		 * Value associated with the 'ON' radio button. 
		 */		
		private static const ON_VALUE:String = "ON";
		
		/**
		 * Value associated with the 'OFF' radio button. 
		 */		
		private static const OFF_VALUE:String = "OFF";
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 * @param viewComponent
		 */		
		public function GuidanceControlsMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			if(!(viewComponent is GuidanceControls))
				throw new Error("Mediator expects a GuidanceControls viewcomponent.");
		}


		// ------------------------------------------------------------------
		// PureMVC METHOD OVERRIDES
		// ------------------------------------------------------------------

		override public function onRegister():void
		{
			// initialise correctly
			viewRef.guidanceRBGroup.selectedValue = (guidanceProxy.isGuidanceOn ? ON_VALUE : OFF_VALUE);
			
			// add event listener after initialising
			viewRef.guidanceRBGroup.addEventListener(Event.CHANGE, onGroupChange);
		}
		
		override public function onRemove():void
		{
			viewRef.guidanceRBGroup.removeEventListener(Event.CHANGE, onGroupChange);
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent property. 
		 * @return 
		 */		
		protected function get viewRef():GuidanceControls
		{
			return viewComponent as GuidanceControls;
		}
		
		/**
		 * Retrieves a reference to the guidance proxy. 
		 * @return 
		 */		
		protected function get guidanceProxy():GuidanceProxy
		{
			return facade.retrieveProxy(GuidanceProxy.NAME) as GuidanceProxy;
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		

		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		
		/**
		 * Event handler - close button clicked 
		 * @param evt
		 */		
		protected function onGroupChange(evt:Event):void
		{
			// get the selected value
			var value:String = viewRef.guidanceRBGroup.selectedValue as String;
			
			// notify the application
			switch(value)
			{
				case "ON":
					sendNotification(Notifications.EDITOR_GUIDANCE_ON);
					break;
					
				case "OFF":
					sendNotification(Notifications.EDITOR_GUIDANCE_OFF);
					break;
			}
		}
		
	}
}