/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.editor
{
	import flash.events.MouseEvent;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * Integrates the PopupMenuView component into the application. 
	 * @author Nils
	 */
	public class PopupMenuViewMediator extends Mediator
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "PopupMenuViewMediator";
		
		
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
		public function PopupMenuViewMediator(viewComponent:PopupMenuView)
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
			viewRef.componentsButton.addEventListener(MouseEvent.CLICK, onComponentsClick);
			viewRef.layoutButton.addEventListener(MouseEvent.CLICK, onLayoutClick);
			updateLayoutName();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			viewRef.componentsButton.removeEventListener(MouseEvent.CLICK, onComponentsClick);
			viewRef.layoutButton.removeEventListener(MouseEvent.CLICK, onLayoutClick);
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function listNotificationInterests():Array
		{
			var list:Array = super.listNotificationInterests();
			
			// need to update page layout label on page change
			list.push(Notifications.APP_PAGE_DRAW);

			// done
			return list;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			
			switch(notification.getName())
			{
				case Notifications.APP_PAGE_DRAW:
					updateLayoutName();
					break;
			}
		}
		

		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():PopupMenuView
		{
			return viewComponent as PopupMenuView;
		}
		
		
		/**
		 * Update the layout name to match currently selected page (if any). 
		 */		
		protected function updateLayoutName():void
		{
			var pageID:int = (facade.retrieveProxy(SelectionProxy.NAME) as SelectionProxy).pageIndex;
			
			// if pageID is out of range for some reason, an exception will be thrown
			// we react by clearing the label text
			try{
				var page:PageInstanceVO = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy).getPageAt(pageID);
				viewRef.pageNameLabel.text = page.layout.name;
			}catch(e:Error){
				viewRef.pageNameLabel.text = "";
			}
		}
		
	
		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------
		
		/**
		 * Event handler - the 'Components' button was clicked.
		 * @param evt
		 */
		protected function onComponentsClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.EDITOR_SHOW_COMPONENTMENU);
		}
		
		/**
		 * Event handler - the 'Layouts' button was clicked. 
		 * @param evt
		 */		
		protected function onLayoutClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.EDITOR_SHOW_LAYOUTMENU);
		}

	}
}