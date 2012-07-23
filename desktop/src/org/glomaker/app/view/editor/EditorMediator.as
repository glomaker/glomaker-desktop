/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.editor
{
	import org.glomaker.app.core.Notifications;
	import org.glomaker.app.model.ProjectSettingsProxy;
	import org.glomaker.app.model.SharedMemoryProxy;
	import org.glomaker.app.utils.Size;
	import org.glomaker.app.view.properties.PropertiesPanelMediator;
	import org.glomaker.app.view.richtexteditor.GloRichTextMediator;
	import org.glomaker.app.view.stage.PageDisplayMediator;
	import org.glomaker.app.view.stage.StageUIMediator;
	import org.glomaker.hotdraw.HotDrawMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class EditorMediator extends Mediator	{
		/**
		 * PureMVC identifier 
		 */
		public static const NAME:String = "EditorMediator";
		
		 // view helper 
		protected var _viewRef:EditorView;

		 // Keep reference to the application
		protected var _appRef:GLO_v2;
		
		public function EditorMediator(viewComponent:EditorView)
		{
			super(NAME, viewComponent);
			_viewRef = viewComponent;
			
		} 
		
		override public function onRegister():void
		{
			facade.registerMediator(new HotDrawMediator(_viewRef.hotDrawApplication));
			facade.registerMediator(new StageUIMediator(_viewRef.stageUIDisplay));
			facade.registerMediator(new PageListMediator(_viewRef.pageList));
			facade.registerMediator(new PropertiesPanelMediator(_viewRef.properties));
			facade.registerMediator(new PopupMenuViewMediator(_viewRef.popupMenu));
			facade.registerMediator(new GuidanceControlsMediator(_viewRef.guidanceControls));
			facade.registerMediator(new GloRichTextMediator(_viewRef.rte));

			// initialise to correct size and colour
			changeSize(new Size(projectProxy.settings.stageWidth, projectProxy.settings.stageHeight));
			changeColour(projectProxy.settings.stageColour);

			// update pattern label
			_viewRef.patternLabel.text = projectProxy.currentPattern.name;

			//switch to first page in sequence
			sendNotification(Notifications.LIST_SELECT_ITEM, 0);
		}
		
		override public function onRemove():void{
			
			facade.removeMediator(HotDrawMediator.NAME);
			facade.removeMediator(StageUIMediator.NAME);
			facade.removeMediator(PageListMediator.NAME);
			facade.removeMediator(PropertiesPanelMediator.NAME);
			facade.removeMediator(PopupMenuViewMediator.NAME);
			facade.removeMediator(GuidanceControlsMediator.NAME);
			facade.removeMediator(GloRichTextMediator.NAME);

			// PageDisplayMediator created by HotdrawViewCanvasCreated command!
			facade.removeMediator(PageDisplayMediator.NAME);
			
			// notify the application
			// bit of a hack to allow for cleanup
			// @todo - generalis this so that each section has a CREATE/REMOVE command that handles
			// Mediator instantiation/initialisation and removal/cleanup
			sendNotification(Notifications.EDITOR_REMOVED);
		}
		
		protected function get sharedMemory():Object
		{
			return SharedMemoryProxy(facade.retrieveProxy(SharedMemoryProxy.NAME)).getSharedMemory();
		}
		
		protected function get projectProxy():ProjectSettingsProxy
		{
			return facade.retrieveProxy(ProjectSettingsProxy.NAME) as ProjectSettingsProxy;
		}
		
		 /**
	 	 * PureMVC callback - list notifications. 
	 	 * @return 
	 	 */		
	 	override public function listNotificationInterests():Array
	 	{
	 		var list:Array = super.listNotificationInterests();
	 	
	 		// stage property changes
	 		list.push(Notifications.CHANGE_STAGE_SIZE);
	 		list.push(Notifications.CHANGE_STAGE_COLOR);
	 		
	 		return list;
	 	}
	 	
	 		/**
	 	 * PureMVC callback - handle incoming notification.
	 	 * @param notification
	 	 */	 	
	 	override public function handleNotification(notification:INotification):void
	 	{
	 		
	 		// current use: tie in legacy code with new PureMVC notification system
	 		switch(notification.getName())
	 		{
	 		
	 			case Notifications.CHANGE_STAGE_SIZE:
	 				changeSize(notification.getBody() as Size);
	 				break;
	 				
	 			case Notifications.CHANGE_STAGE_COLOR:
	 				changeColour(notification.getBody() as uint);
	 				break;
	 					
	 		}
	 	}
	 	
	 	protected function changeSize(size:Size):void
		{
			_viewRef.backgroundCanvas.width = size.width;
			_viewRef.backgroundCanvas.height = size.height;

			_viewRef.pageDisplay.minWidth = size.width;
			_viewRef.pageDisplay.minHeight = size.height;
			
			_viewRef.stageUIDisplay.width = size.width;
			_viewRef.stageUIDisplay.height = size.height;
		}
		
		protected function changeColour(rgb:uint):void
		{
			_viewRef.backgroundCanvas.setStyle("backgroundColor", rgb);
		}
		
	}
}