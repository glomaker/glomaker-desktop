/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.nav
{
	import flash.events.MouseEvent;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ApplicationStateProxy;
	import org.glomaker.app.view.components.AppNavBar;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;


	/**
	 * Integrates the navigation bar into the application. 
	 * @author Nils
	 */
	public class NavBarMediator extends Mediator
	{
		
		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------
				
		/**
		 * PureMVC identifier 
		 */		
		public static const NAME:String = "NavBarMediator";


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor
		 */		
		public function NavBarMediator(viewComponent:AppNavBar)
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
			
			// event listeners
			navBar.leftDesignerButton.addEventListener(MouseEvent.CLICK, onDesignerClick);
			navBar.rightDesignerButton.addEventListener(MouseEvent.CLICK, onDesignerClick);
			navBar.plannerButton.addEventListener(MouseEvent.CLICK, onPlannerClick);
			navBar.previewButton.addEventListener(MouseEvent.CLICK, onPreviewClick);
		}	
		
		/**
		 * @inheritDoc
		 */		
		override public function onRemove():void
		{
			super.onRemove();
			
			// cleanup
			navBar.leftDesignerButton.removeEventListener(MouseEvent.CLICK, onDesignerClick);
			navBar.rightDesignerButton.removeEventListener(MouseEvent.CLICK, onDesignerClick);
			navBar.plannerButton.removeEventListener(MouseEvent.CLICK, onPlannerClick);
			navBar.previewButton.removeEventListener(MouseEvent.CLICK, onPreviewClick);
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			// view switches require navbar state update
			list.push(ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION);
			
			// done
			return list;
		}
		
		
		/**
		 * @inheritDoc 
		 */		
		 override public function handleNotification(notification:INotification):void
		 {
		 	switch(notification.getName())
		 	{

		 		case ApplicationStateProxy.SECTION_CHANGE_NOTIFICATION:
		 		
		 			switch( notification.getBody() )
		 			{
		 				case ApplicationStateProxy.SECTION_PATTERNMAKER:
			 				navBar.currentState = AppNavBar.PLANNER_STATE;
				 			break;
		 				case ApplicationStateProxy.SECTION_EDITOR:
			 				navBar.currentState = AppNavBar.DESIGNER_STATE;
				 			break;
		 				case ApplicationStateProxy.SECTION_PLAYER:
				 			navBar.currentState = AppNavBar.PREVIEW_STATE;
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
		protected function get navBar():AppNavBar
		{
			return viewComponent as AppNavBar;
		}
		
		
		// ------------------------------------------------------------------
		// EVENT LISTENERS
		// ------------------------------------------------------------------
		
		protected function onDesignerClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.APP_REQUEST_SHOW_EDITOR);
		}
		
		protected function onPlannerClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.APP_REQUEST_SHOW_PATTERNMAKER);
		}
		
		protected function onPreviewClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.APP_REQUEST_SHOW_PLAYER);
		}
		
	}
}