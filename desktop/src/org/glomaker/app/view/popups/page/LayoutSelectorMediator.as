/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.page
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.PagePluginProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SelectionProxy;
	import org.glomaker.app.view.popups.PopupMediator;
	import org.glomaker.common.vo.PageInstanceVO;
	import org.glomaker.common.vo.PageVO;

	/**
	 * Integrates the LayoutSelector component into the application. 
	 * @author Nils
	 */
	public class LayoutSelectorMediator extends PopupMediator
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "LayoutSelectorMediator";
		
		
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
		public function LayoutSelectorMediator(viewComponent:LayoutSelector)
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
			populateFromProxy();
			
			viewRef.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
			viewRef.okButton.addEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.layoutList.addEventListener(MouseEvent.DOUBLE_CLICK, onOKClick);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onRemove():void
		{
			super.onRemove();
			viewRef.layoutList.dataProvider = null;
			
			viewRef.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
			viewRef.okButton.removeEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.layoutList.removeEventListener(MouseEvent.DOUBLE_CLICK, onOKClick);
		}
		

		// ------------------------------------------------------------------
		// PROTECTED / PRIVATE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():LayoutSelector
		{
			return viewComponent as LayoutSelector;
		}
		
		
		/**
		 * Populate the view with data retrieved from the proxy. 
		 */		
		protected function populateFromProxy():void
		{
			var proxy:PagePluginProxy = facade.retrieveProxy(PagePluginProxy.NAME) as PagePluginProxy;
			var page:PageInstanceVO = getSelectedPage();
			
			// information text
			viewRef.currentInfo.text = "Current layout: " + page.layout.name;
			
			// layout list
			viewRef.layoutList.dataProvider = proxy.getSortedLayouts();
		}
		
		
		/**
		 * Get a reference to the PageInstanceVO currently being displayed. 
		 * @return 
		 */		
		protected function getSelectedPage():PageInstanceVO
		{
			var pageID:int = (facade.retrieveProxy(SelectionProxy.NAME) as SelectionProxy).pageIndex;
			var page:PageInstanceVO;
						
			// if pageID is out of range for some reason, an exception will be thrown
			try{
				page = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy).getPageAt(pageID);
				return page;
			}catch(e:Error){};
			
			// none found
			return null;
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
			var layout:PageVO = viewRef.layoutList.selectedItem as PageVO;
			
			if(layout)
				sendNotification(Notifications.PAGE_LAYOUT_REQUEST, layout);
				
			// cleanup
			removePopup();
		}
		
		/**
		 * Event handler - the 'filter' checkbox was checked/unchecked. 
		 * @param evt
		 * 
		 */
		protected function onFilterChange(evt:Event):void
		{
			// refresh data display
			populateFromProxy();
		}

	}
}