/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.properties
{
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.HotDrawProxy;
	import org.glomaker.hotdraw.ComponentProxyFigure;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class PropertiesPanelMediator extends Mediator
	{
		
		// view helper used to display components
		protected var _viewRef:HorzPropertiesPanelView;

		
		/**
		 * PureMVC framework identifier 
		 */
		 
		public static const NAME:String = "PropertiesPanelMediator";
		
		
		public function PropertiesPanelMediator(viewComponent:HorzPropertiesPanelView)
		{
			super(NAME, viewComponent);
			_viewRef = viewComponent;
		}
		
		override public function onRegister():void{
		// Check if there is a figure (component) selected on the stage then
	    // show its properties
		  var fig:ComponentProxyFigure = HotDrawProxy(facade.retrieveProxy(HotDrawProxy.NAME)).currentFigure;
		  if(fig){
  		  	_viewRef.generateControls(fig);
  		  }else{
  		  	_viewRef.clearControls();
  		  }
		}
		
		override public function onRemove():void{
			// remove the current figure
			// @todo - mediators should never manipulate proxy data directly - move this into a command!
			HotDrawProxy(facade.retrieveProxy(HotDrawProxy.NAME)).currentFigure = null;
			 _viewRef.clearControls();
		}

		/**
		 * PureMVC integration - list notification interests. 
		 * @return 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			// properties need to be shown / hidden when components are selected / deselected on the stage
			list.push(Notifications.HOTDRAW_FIGURESELECTED);
			list.push(Notifications.HOTDRAW_CLEARSELECTION);
			
			list.push(Notifications.COMPONENT_EDIT_MODE);
			list.push(Notifications.COMPONENT_NORMAL_MODE);
			
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
			
			// figure might be null
			var fig:ComponentProxyFigure = notification.getBody() as ComponentProxyFigure;
			
			// run update logic
			updatePropertiesPanel(notification.getBody() as ComponentProxyFigure, notification.getName());
		}
		
		
		
		/**
		 * Shows / hides / updates the properties panel.
		 * Various different notifications occur when the user clicks, selects, deselects components.
		 * These are all picked apart here and the properties panel is updated accordingly.
		 *  
		 * @param fig
		 * @param notificationName
		 */		
		protected function updatePropertiesPanel( fig:ComponentProxyFigure, notificationName:String):void
		{
			
			// figure that hotdraw currently thinks is active
			// we also store our same history in _selectedFigure 
			var hotDrawCurrentFigure:ComponentProxyFigure = HotDrawProxy(facade.retrieveProxy(HotDrawProxy.NAME)).currentFigure;

			// if either the hotDrawCurrentFigure or the figure passed in via the notification is valid, we show property panel
			var selectedFigure:ComponentProxyFigure;
			
			if(hotDrawCurrentFigure)
				selectedFigure = hotDrawCurrentFigure;
			else if(fig)
				selectedFigure = fig;
				
			// toggle controls
			if(selectedFigure)
				_viewRef.generateControls( selectedFigure );
			else
				_viewRef.clearControls();
		}
		
		
	}
}