/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.stage
{
	import com.hotdraw.CH.ifa.draw.standard.StandardDrawingView;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.events.PageComponentEvent;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Integrates the StageLoader view component into the application. 
	 * @author Nils
	 */	
	public class PageDisplayMediator extends BaseComponentDisplayMediator
	{
		
		/**
		 * PureMVC framework identifier 
		 */
		public static const NAME:String = "PageDisplayMediator";
		

		/**
		 * Constructor 
		 * @param viewComponent
		 */		
		public function PageDisplayMediator(viewComponent:StandardDrawingView)
		{
			super(NAME, new HotdrawAwareComponentDisplayView(viewComponent));
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			displayView.addEventListener(PageComponentEvent.ADDED, onComponentAdded);
			displayView.addEventListener(PageComponentEvent.REMOVED, onComponentRemoved);
			drawCurrentPage();
		}
		
		override public function onRemove():void
		{
			displayView.removeEventListener(PageComponentEvent.ADDED, onComponentAdded);
			displayView.removeEventListener(PageComponentEvent.REMOVED, onComponentRemoved);
			displayView.clear();
			super.onRemove();
		}


		/**
		 * PureMVC integration - list notification interests. 
		 * @return 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			// need notification when a new page has been selected in the list
			list.push(Notifications.APP_SAVE_DATA);
			list.push(Notifications.APP_PAGE_DRAW);
			
			//
			return list;
		}
		
		
		/**
		 * PureMVC integration - handling incoming notifications. 
		 * @param notification
		 */		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			
			//
			switch(notification.getName())
			{
				case Notifications.APP_SAVE_DATA:
				
					//
					displayView.save();
					
					//
					break;
				
				case Notifications.APP_PAGE_DRAW:
				
					// body contains new page definition
					var page:PageInstanceVO = notification.getBody() as PageInstanceVO;

					if(page)
					{
						displayView.clear();
						displayView.addComponentList(page.components);

						// make sure components have the correct status information
						sendStatusUpdate();
					}				

					// done						
					break;
			}
		}


		protected function drawCurrentPage():void
		{
			var pageID:int = selectionProxy.pageIndex;
			// var pageID:int = project.settings.pageID;
			
			try{
				var page:PageInstanceVO = project.getPageAt(pageID);
				
				displayView.clear();
				displayView.addComponentList(page.components);
			}catch(e:Error){}
		}

		protected function get project():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}
		
		protected function get selectionProxy():SelectionProxy
		{
			return facade.retrieveProxy(SelectionProxy.NAME) as SelectionProxy;
		}
		
		/**
		 * A component has been added to the page. 
		 * @param evt
		 */		
		protected function onComponentAdded(evt:PageComponentEvent):void
		{
			// notify the application so it can update the model
			if(evt.componentInstance)
			{
				sendNotification(Notifications.PAGE_ADD_COMPONENT, evt.componentInstance);
			}
		}
		
		/**
		 * A component has been removed from the current page. 
		 * @param evt
		 */
		protected function onComponentRemoved(evt:PageComponentEvent):void
		{
			// notify the application so it can update the model
			if(evt.componentInstance)
			{
				sendNotification(Notifications.PAGE_REMOVE_COMPONENT, evt.componentInstance);
			}
		}	

	}
}