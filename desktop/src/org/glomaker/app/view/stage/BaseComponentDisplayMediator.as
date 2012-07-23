/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.stage
{
	import mx.controls.Alert;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.events.NavigationEvent;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.app.model.SharedMemoryProxy;
	import org.glomaker.common.data.SlideshowStatusVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * A base class for creating specific ComponentDisplay Mediator implementations.
	 * Provides integration of component slideshow navigation and slideshow status update handling.
	**/
	public class BaseComponentDisplayMediator extends Mediator
	{

		/**
		 * Constructor 
		 * @param mediatorName
		 * @param viewComponent
		 */
		public function BaseComponentDisplayMediator(mediatorName:String, viewComponent:ComponentDisplayView)
		{
			super(mediatorName, viewComponent);
		}
		
		/**
		 * PureMVC integration.
		 * Initialisation code when the mediator has been registered with the framework.
		 */		
		override public function onRegister():void
		{
			// pass shared memory to the display view
			var sharedMemProxy:SharedMemoryProxy = facade.retrieveProxy(SharedMemoryProxy.NAME) as SharedMemoryProxy;
			displayView.setSharedMemory(sharedMemProxy.getSharedMemory());
			
			// add view event listeners
			displayView.addEventListener(NavigationEvent.PREVIOUS, onNavPrevious);
			displayView.addEventListener(NavigationEvent.NEXT, onNavNext);
			displayView.addEventListener(NavigationEvent.GOTO, onNavGoto);
		}


		/**
		 * PureMVC integration.
		 * Cleanup code when the mediator has been removed from the framework.
		 * Also calls 'destroy()' on displayView.
		 */		
		override public function onRemove():void
		{
			// cleanup
			displayView.removeEventListener(NavigationEvent.PREVIOUS, onNavPrevious);
			displayView.removeEventListener(NavigationEvent.NEXT, onNavNext);
			displayView.removeEventListener(NavigationEvent.GOTO, onNavGoto);
			
			//
			displayView.destroy();
		}
		
		
		/**
		 * PureMVC integration - list notification interests. 
		 * @return 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			// need to notify components if selected page has changed
			list.push(SelectionProxy.SELECTED_PAGE_UPDATED);
			
			//
			return list;
		}
		
		
		/**
		 * PureMVC integration - handling incoming notifications. 
		 * @param notification
		 * 
		 */		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			
			switch(notification.getName())
			{
				case SelectionProxy.SELECTED_PAGE_UPDATED:
				
					// send slideshow update information back to the component
					// @todo - handle this on the application level instead, as a new notification
					sendStatusUpdate();
					break;
			}
		}		
		
		
		/**
		 * Creates a new SlideshowStatusVO instance with correct properties and sends it to the view component.
		**/
		protected function sendStatusUpdate():void
		{
			var selection:SelectionProxy = facade.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
			var project:ProjectSettingsProxy = facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;

			// create status object			
			var statusVO:SlideshowStatusVO = new SlideshowStatusVO(project.settings.pages.length, selection.pageIndex);
			
			// send to view component
			displayView.handleSlideshowStatus(statusVO);
		}		
		
		
		/**
		 * Event handler - go to previous page. 
		 * @param evt
		 */		
		protected function onNavPrevious(evt:NavigationEvent):void
		{
			// notify the application
			sendNotification(Notifications.NAV_REQUEST_PREVIOUS);
		}
		
		
		/**
		 * Event handler - go to next page. 
		 * @param evt
		 */		
		protected function onNavNext(evt:NavigationEvent):void
		{
			// notify the application
			sendNotification(Notifications.NAV_REQUEST_NEXT);
		}


		/**
		 * Event handler - go to previous page. 
		 * @param evt
		 */		
		protected function onNavGoto(evt:NavigationEvent):void
		{
			// notify the application
			sendNotification(Notifications.NAV_REQUEST_GOTO, evt.pageIndex);
		}
		
		
		/**
		 * Typed access to the view component. 
		 * @return 
		 */		
		public function get displayView():ComponentDisplayView
		{
			return viewComponent as ComponentDisplayView;
		}
		
	}
}