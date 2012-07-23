/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.editor
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.GuidanceProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.view.components.list.PedagogicalSequenceList;
	import org.glomaker.app.view.components.list.SequenceListItemRenderer;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;	
	/**
	 * Integrates the PageList view component with the PureMVC framework. 
	 * @author USER
	 * 
	 */
	public class PageListMediator extends Mediator
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * PureMVC identifier  
		 */
		public static const NAME:String = "PageListMediator";


		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * Constructor 
		 * @param viewComponent
		 */
		public function PageListMediator(viewComponent:PedagogicalSequenceList)
		{
			super(NAME, viewComponent);
			
		}


		// ------------------------------------------------------------------
		// PUREMVC OVERRIDES
		// ------------------------------------------------------------------
		
		/**
		 * @inheritDoc 
		 */		
		override public function onRegister():void
		{
			// populate the list
			populateFromProxy();

			// add event listeners afterwards
			viewRef.addEventListener(ListEvent.CHANGE, onListChange);
			viewRef.addEventListener(SequenceListItemRenderer.GUIDANCE_CLICKED, onShowGuidanceClicked);
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function onRemove():void{
	        viewRef.removeEventListener(ListEvent.CHANGE, onListChange);
	        viewRef.removeEventListener(SequenceListItemRenderer.GUIDANCE_CLICKED, onShowGuidanceClicked);
	        viewRef.dataProvider = new ArrayCollection(); // clear the list
		}	

		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			list.push(Notifications.LIST_SELECT_ITEM);
			list.push(Notifications.APP_REFRESH_DISPLAY);
			list.push(Notifications.EDITOR_GUIDANCE_ON);
			list.push(Notifications.EDITOR_GUIDANCE_OFF);
			
			return list;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.APP_REFRESH_DISPLAY:
					populateFromProxy();		
					break;
				
				case Notifications.LIST_SELECT_ITEM:
					// body contains selected index
					var index:int = notification.getBody() as int;
					if(viewRef.selectedIndex != index)
					{
						viewRef.selectedIndex = index;
					}
						
					break;
					
				case Notifications.EDITOR_GUIDANCE_ON:
					viewRef.showGuidance = true;
					break;
					
				case Notifications.EDITOR_GUIDANCE_OFF:
					viewRef.showGuidance = false;
					break;
					
			}
			
		}

		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------

			
		/**
		 * Casts viewComponent to List class 
		 * @return List instance
		 */		
		protected function get viewRef():PedagogicalSequenceList
		{
			return viewComponent as PedagogicalSequenceList;
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
		
		
		protected function populateFromProxy():void
		{
			// pages
			var proxy:IProxy = facade.retrieveProxy(ProjectSettingsProxy.NAME);
			var pages:ArrayCollection = (proxy as ProjectSettingsProxy).settings.pages;
			viewRef.dataProvider = pages;

			// guidance on/off
			viewRef.showGuidance = guidanceProxy.isGuidanceOn;
			
			// when guidance is on, the list is not always refreshed correctly
			// we fix that by forcing the list to be redrawn again, now that data + state have been set
			viewRef.forceListUpdate();
		}
		

		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		/**
		 * Event handler - list selection has changed.
		 * @param evt
		**/
		protected function onListChange(evt:ListEvent):void
		{
			// switch to the next one
			sendNotification(Notifications.LIST_SELECT_ITEM, viewRef.selectedIndex);
		}
		
		
		/**
		 * Event handler - the selected item's 'show guidance' button was clicked. 
		 * @param evt
		 * 
		 */		
		protected function onShowGuidanceClicked(evt:Event):void
		{
			// notify the application (body contains the selected page instance)
			if(viewRef.selectedItem)
			{
				sendNotification(Notifications.EDITOR_GUIDANCE_SHOW, viewRef.selectedItem);
			}
		}
	
		
	
	}
}