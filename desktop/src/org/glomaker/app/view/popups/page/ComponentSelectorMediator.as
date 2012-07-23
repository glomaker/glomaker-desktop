/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.page
{
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ComponentPluginProxy;
	import org.glomaker.app.view.popups.PopupMediator;
	import org.glomaker.common.vo.ComponentVO;

	/**
	 * Integrates the ComponentSelectorMediator component into the application. 
	 * @author Nils
	 */
	public class ComponentSelectorMediator extends PopupMediator
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "ComponentSelectorMediator";
		
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * @constructor 
		 * @param viewComponent
		 */		
		public function ComponentSelectorMediator(viewComponent:ComponentSelector)
		{
			super(NAME, viewComponent);
		}
		

		// ------------------------------------------------------------------
		// PUREMVC INTEGRATION
		// ------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function onRegister():void
		{
			super.onRegister();
			// text
			viewRef.instructionText.text = "Select a component and press 'Ok'.\nThen draw the component on to the screen using the mouse.";
			
			// component list
			viewRef.listData = componentProxy.getSortedList();
			
			// event listeners
			viewRef.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
			viewRef.okButton.addEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.componentList.addEventListener(MouseEvent.DOUBLE_CLICK, onOKClick);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			super.onRemove();
			viewRef.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
			viewRef.okButton.removeEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.componentList.removeEventListener(MouseEvent.DOUBLE_CLICK, onOKClick);
		}
		

		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():ComponentSelector
		{
			return viewComponent as ComponentSelector;
		}
		
		/**
		 * Returns the ComponentPluginProxy instance currently registered with the application. 
		 * @return 
		 */		
		protected function get componentProxy():ComponentPluginProxy
		{
			return facade.retrieveProxy(ComponentPluginProxy.NAME) as ComponentPluginProxy;
		}
		
		
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		/**
		 * Event handler - the 'Cancel' button was clicked.
		 * @param evt
		 */
		protected function onCancelClick(evt:MouseEvent):void
		{
			// cleanup
			removePopup();
		}
		
		/**
		 * Event handler - the 'OK' button was clicked. 
		 * @param evt
		 */		
		protected function onOKClick(evt:MouseEvent):void
		{
			// get the selected layout
			var component:ComponentVO = viewRef.componentList.selectedItem as ComponentVO;
			
			if(component)
				sendNotification(Notifications.COMPONENT_LIBRARY_SELECT, component);	
				
			// cleanup
			removePopup();
		}

	}
}