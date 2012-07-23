/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.richtexteditor
{
	import mx.controls.TextArea;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.hotdraw.ComponentProxyFigure;
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.IComponentProperty;
	import org.glomaker.shared.properties.RichTextProperty;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class GloRichTextMediator extends Mediator
	{
		
	    // view helper used to display components
		protected var _viewRef:GloRichTextEditor;
		
		/**
		 * PureMVC framework identifier 
		 */
		 
		public static const NAME:String = "GloRichTextMediator";
		
		
		
		public function GloRichTextMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_viewRef = GloRichTextEditor(viewComponent);
			disableView();
		}
		
				
		 /**
	 	 * PureMVC callback - list notifications. 
	 	 * @return 
	 	 */		
	 	override public function listNotificationInterests():Array
	 	{
	 		var list:Array = super.listNotificationInterests();
	 	
	 		list.push(Notifications.COMPONENT_EDIT_MODE);
	 		list.push(Notifications.COMPONENT_NORMAL_MODE);
	 		list.push(Notifications.HOTDRAW_CLEARSELECTION);
	 		list.push(Notifications.APP_PAGE_DRAW);
	 		
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
	 			case Notifications.APP_PAGE_DRAW:
	 				// page redrawn - textarea no longer selected.
	 				disableView();
	 				break;
	 			
	 			case Notifications.HOTDRAW_CLEARSELECTION:
	 			case Notifications.COMPONENT_NORMAL_MODE:
	 				disableView();
		 			break;
	 			
	 			case Notifications.COMPONENT_EDIT_MODE:
	 			
	 			var fig:ComponentProxyFigure = notification.getBody() as ComponentProxyFigure;
        		// sort out controls for the custom properties			
				var iPlugin:IComponentPlugin = fig.getContent() as IComponentPlugin;
			
				if(iPlugin)
				{
					// get custom properties from the plugin
					var props:Array = iPlugin.getSaveableProperties();
					var prop:IComponentProperty;
					
					// cycle through each property and create custom controls for it
					for each(prop in props)
					{
							 if(prop is RichTextProperty){
							 	var textArea:TextArea = RichTextProperty(prop).textArea;
							 	if(textArea){
							 		_viewRef.enabled= true;
							 		_viewRef.setTextArea(textArea);
							 	}
							 	
							}
					}
				}
			
	 			break;
	 			
	 			
	 		}
	 	}
	 	
	 	
	 	protected function disableView():void
	 	{
	 		_viewRef.enabled = false;
	 		_viewRef.removeTextArea();
	 	}
		
	}
}