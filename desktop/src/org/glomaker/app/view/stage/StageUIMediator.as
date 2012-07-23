/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.stage
{
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.modules.IModuleInfo;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.common.data.StageVO;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Integrates the StageLoader view component into the application. 
	 * @author Nils
	 * 
	 */	
	public class StageUIMediator extends BaseComponentDisplayMediator
	{

		/**
		 * PureMVC framework identifier 
		 */
		public static const NAME:String = "StageUIMediator";
		
		
		// current stage
		protected var _currentStage:ComponentInstanceVO;
		protected var _moduleInfo:IModuleInfo;
		
		
		/**
		 * Constructor 
		 * @param viewComponent
		 */		
		public function StageUIMediator(viewComponent:Canvas)
		{
			super(NAME, new ComponentDisplayView(viewComponent));
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			// currently selected stage is stored in proxy
			var proxy:ProjectSettingsProxy = facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
				
			// display it
			displayStage(proxy.settings.selectedStage.componentInstance);
		}

		
		protected function displayStage(stage:ComponentInstanceVO):void
		{
			_currentStage = stage;
			displayView.clear();
			displayView.addComponent(stage);
			
			// make sure stage component has the correct status information
			sendStatusUpdate();
		}
		
		protected function changeSize(size:Point):void
		{
			ComponentDisplayView(viewComponent).setSize(size.x,size.y);
		}
		
		 /**
	 	 * PureMVC callback - list notifications. 
	 	 * @return 
	 	 */		
	 	override public function listNotificationInterests():Array
	 	{
	 		var list:Array = super.listNotificationInterests();
	 	
	 		// startup messages
	 		list.push(Notifications.CHANGE_STAGE);
	 			
	 		return list;
	 	}
	 	
	 	
	 	/**
	 	 * PureMVC callback - handle incoming notification.
	 	 * @param notification
	 	 */	 	
	 	override public function handleNotification(notification:INotification):void
	 	{
	 		super.handleNotification(notification);
	 		
	 		// current use: tie in legacy code with new PureMVC notification system
	 		switch(notification.getName())
	 		{
	 			case Notifications.CHANGE_STAGE:
	 				var stage:StageVO =  notification.getBody() as StageVO;
	 				displayStage(stage.componentInstance);
	 				break;

	 		}
	 	}

	}
}