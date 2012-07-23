/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.popups.stage
{
	import flash.events.MouseEvent;
	
	import mx.managers.PopUpManager;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ConfigProxy;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.StagePluginProxy;
	import org.glomaker.app.utils.Size;
	import org.glomaker.app.view.popups.PopupMediator;
	import org.glomaker.common.data.StageVO;

	
	/**
	 * Integrates the StagePropertiesPopup view component into the application. 
	 * @author Nils
	 */	
	public class StagePropertiesPopupMediator extends PopupMediator
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
	
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "StagePropertiesPopupMediator";
		
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
				
		public function StagePropertiesPopupMediator(viewComponent:StagePropertiesPopup)
		{
			super(NAME, viewComponent);
		}


		// ------------------------------------------------------------------
		// PUREMVC INTEGRATION
		// ------------------------------------------------------------------
		
		override public function onRegister():void
		{
			super.onRegister();
			populateFromProxy();
			
			// Add event listeners
			viewRef.okButton.addEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.cancelButton.addEventListener(MouseEvent.CLICK, onCancelClick);
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			viewRef.stageStyle.dataProvider = null;
			viewRef.stageSize.dataProvider = null;
			
			// Remove events listeners
			viewRef.okButton.removeEventListener(MouseEvent.CLICK, onOKClick);
			viewRef.cancelButton.removeEventListener(MouseEvent.CLICK, onCancelClick);
		}


		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------

		
		/**
		 * Returns a typed reference to the viewComponent. 
		 * @return 
		 */		
		protected function get viewRef():StagePropertiesPopup
		{
			return viewComponent as StagePropertiesPopup;
		}


		/**
		 * Populate the view component from data stored in the model layer. 
		 */
		protected function populateFromProxy():void
		{			
			var stagePlugins:StagePluginProxy = (facade.retrieveProxy(StagePluginProxy.NAME) as StagePluginProxy); 
			var projectProxy:ProjectSettingsProxy = (facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy); 
			var configProxy:ConfigProxy = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy);

			// display first stage definition
			var list:Array = stagePlugins.getSortedStageList();
			viewRef.stageStyle.dataProvider = list;
			viewRef.stageStyle.selectedItem = projectProxy.settings.selectedStage; 
			
			// Initialise the stage sizes list with default values
			var sizes:Array =  [
				{label: "320x240", data: new Size(320,240)},
				{label: "640x480", data: new Size(640,480)},
				{label: "700x420", data: new Size(700, 420)},
				{label: "800x600", data: new Size(800,600)},
				{label: "1024x768", data: new Size(1024,768)},
				{label: "Custom..."}
			];

			viewRef.stageSize.dataProvider = sizes;
			
			// select correct size
			var sw:Number = projectProxy.settings.stageWidth;
			var sh:Number = projectProxy.settings.stageHeight;
			var o:Object;
			
			for each(o in sizes)
			{
				if(o.data && o.data.width == sw && o.data.height == sh)
				{
					// found a match
					break;
				}
			}
			
			// if o isn't set, no match could be found
			// so we use the last entry, which is the 'custom' entry
			if(!o)
				o = sizes[sizes.length - 1];
				
			// select it
			viewRef.stageSize.selectedItem = o;
			viewRef.updateCustomSize();
			
			// make sure fields are updated
			viewRef.widthInput.text = String(sw);
			viewRef.heightInput.text = String(sh);
			
			// select correct colour
			viewRef.stageColor.selectedColor = projectProxy.settings.stageColour;
		}
		

		// ------------------------------------------------------------------
		// EVENT HANDLERS
		// ------------------------------------------------------------------

		protected function onOKClick(evt:MouseEvent):void
		{
			sendNotification(Notifications.CHANGE_STAGE,viewRef.stageStyle.selectedItem as StageVO);
			sendNotification(Notifications.CHANGE_STAGE_SIZE, new Size(Number(viewRef.widthInput.text), Number(viewRef.heightInput.text)));
			sendNotification(Notifications.CHANGE_STAGE_COLOR,viewRef.stageColor.selectedColor as uint);
			removePopup();
		}
		
		protected function onCancelClick(evt:MouseEvent):void
		{
			removePopup();
		}
		
	}
}