/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.guidance
{
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ApplicationStateProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;


	/**
	 * Integrates the GuidancePopup view component with the application. 
	 * Doesn't extend PopupMediator because we don't want these popups to be hidden on CLOSE_ALL_POPUPS Notification.
	 * @author Nils
	 */
	public class GuidancePopupMediator extends Mediator
	{
		
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC Identifier 
		 */
		public static const NAME:String = "GuidancePopupMediator";
		
		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 * @param viewComponent
		 */		
		public function GuidancePopupMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			if(!(viewComponent is GuidancePopup))
				throw new Error("Mediator expects a GuidancePopup viewcomponent.");
		}


		// ------------------------------------------------------------------
		// PureMVC METHOD OVERRIDES
		// ------------------------------------------------------------------

		override public function onRegister():void
		{
			super.onRegister();
			popup.addEventListener(CloseEvent.CLOSE, onClose);
			populateFromProxy();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			popup.removeEventListener(CloseEvent.CLOSE, onClose);
		}
		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			list.push(Notifications.EDITOR_GUIDANCE_OFF);
			list.push(Notifications.APP_PAGE_DRAW);
			
			list.push(ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION);
			
			return list;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.EDITOR_GUIDANCE_OFF:
					unregister();
					break;
					
				case Notifications.APP_PAGE_DRAW:
					populateFromProxy();
					break;
					
				case ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION:
				
					switch( notification.getBody() )
					{
						case ApplicationStateProxy.SECTION_PATTERNMAKER:
						case ApplicationStateProxy.SECTION_PLAYER:
							// now showing patternmaker / player view
							// the mediator will survive the switch between pages
							// guidance panel is not required in those views
							popup.visible = false;
							break;
						
						case ApplicationStateProxy.SECTION_EDITOR:
							// now showing editor view
							// the mediator will survive the switch between pages
							// if it is still registered, that means the guidance was showing when we left the editor
							// guidance panel is required in those views
							popup.visible = true;
							break;
					}
					
					break;
				
			}
		}
		
		
		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent property. 
		 * @return 
		 */		
		protected function get popup():GuidancePopup
		{
			return viewComponent as GuidancePopup;
		}
		
		/**
		 * Returns the SelectionProxy instance current registered with the application. 
		 * @return 
		 */
		protected function get selectionProxy():SelectionProxy
		{
			return facade.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
		}

		/**
		 * Returns the ProjectSettingsProxy instance current registered with the application. 
		 * @return 
		 */
		protected function get projectProxy():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}

		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Cleanup method. 
		 * Unregisters the mediator and remove the popup.
		 */	
		protected function unregister():void
		{
			facade.removeMediator(getMediatorName());
			PopUpManager.removePopUp(popup);
			setViewComponent(null);
		}
		
		
		/**
		 * Populate view component from currently selected page. 
		 */		
		protected function populateFromProxy():void
		{
			var page:PageInstanceVO;
			
			try{
				
				// retrieve page
				page = projectProxy.getPageAt(selectionProxy.pageIndex);
				
				// guidance resides in function associated with the node
				popup.displayGuidance(page.node.func.guidance);
				
				
			}catch(e:Error){
				
				// invalid index stored in selectionProxy (probably because no page is selected)
				// or null pointer when trying to access data
				popup.clearGuidance();
				
			}
			
		}


		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		
		/**
		 * Event handler - close button clicked 
		 * @param evt
		 */		
		protected function onClose(evt:CloseEvent):void
		{
			// notify the application
			// sendNotification(Notifications.CREATE_NEW_PATTERNSELECT, pattern);
			
			// remove popup and the mediator instance - they are no longer required
			unregister();
		}
		
	}
}