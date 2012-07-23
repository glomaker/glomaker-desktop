/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw
{
	import com.hotdraw.CH.ifa.draw.framework.Tool;
	
	import flash.events.Event;
	
	import org.glomaker.app.core.Notifications;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.ComponentVO;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	public class HotDrawMediator extends Mediator
	{
		public static const NAME:String = "HotDrawMediator";
		private var hotDrawApp:HotDrawApplication = null;
		
		public function HotDrawMediator(viewComponent:HotDrawApplication)
		{
			super(NAME, viewComponent);
			hotDrawApp = viewComponent;
	 }
		
        override public function onRegister():void{

        	hotDrawApp.addEventListener(HotDrawApplication.TOOLDONE,toolDone);
        	hotDrawApp.addEventListener(HotDrawApplication.SELECTIONCHANGED,selectionChanged);
        	hotDrawApp.getGloDrawingView().addEventListener(HotDrawApplication.COMPONENTEDITMODE,componentEditMode);
        	hotDrawApp.getGloDrawingView().addEventListener(HotDrawApplication.COMPONENTNORMALMODE,componentNormalMode);
        	hotDrawApp.getGloDrawingView().addEventListener(HotDrawApplication.COMPONENTSENDBACK,componentSendBack);
        	hotDrawApp.getGloDrawingView().addEventListener(HotDrawApplication.COMPONENTBRINGFRONT,componentBringFront);
			hotDrawApp.registerEvents();
        	
        	// Send a notification to pass on the Drawing Canvas of HotDraw
        	sendNotification(Notifications.HOTDRAW_STANDARDDRAWINGCANVASCREATED,hotDrawApp.view());

        }
        
        override public function onRemove():void{
        	hotDrawApp.removeEventListener(HotDrawApplication.TOOLDONE,toolDone);
        	hotDrawApp.removeEventListener(HotDrawApplication.SELECTIONCHANGED,selectionChanged);
        	hotDrawApp.getGloDrawingView().removeEventListener(HotDrawApplication.COMPONENTEDITMODE,componentEditMode);
        	hotDrawApp.getGloDrawingView().removeEventListener(HotDrawApplication.COMPONENTNORMALMODE,componentNormalMode);
            hotDrawApp.getGloDrawingView().removeEventListener(HotDrawApplication.COMPONENTSENDBACK,componentSendBack);
        	hotDrawApp.getGloDrawingView().removeEventListener(HotDrawApplication.COMPONENTBRINGFRONT,componentBringFront);
        	hotDrawApp.getGloDrawingView().clearSelection();
        	hotDrawApp.unregisterEvents();
        }
		
		override public function listNotificationInterests():Array{
			return [Notifications.COMPONENT_LIBRARY_SELECT, Notifications.APP_PAGE_DRAW];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName())
			{
				case Notifications.COMPONENT_LIBRARY_SELECT: 

					// body contains the component definition that has been selected			
					var vo:ComponentVO = notification.getBody() as ComponentVO;
					
					// create a new ComponentInstance from it (no initial properties)
					var instance:ComponentInstanceVO = new ComponentInstanceVO(vo);
					
					// create the HotDraw figure that will be used to draw this component
					var figure:ComponentProxyFigure = new ComponentProxyFigure(instance);

					// create and select a tool loaded with this figure					
					var tool:Tool= new DisposableCreationTool(hotDrawApp.view(), figure);
					hotDrawApp.setTool(tool);
					
					// done
					break;
					
				case Notifications.APP_PAGE_DRAW:
					// page is being redrawn
					// no components should be selected
					hotDrawApp.getGloDrawingView().clearSelection();
					break;
			}
		}
		
		
	  private function componentEditMode(e:Event):void {
	  	     var c:ComponentProxyFigure = (hotDrawApp.view() as GloDrawingView).lastDblClickedFigure;
	  		 sendNotification(Notifications.COMPONENT_EDIT_MODE,c);
	  }
	  
	  private function componentNormalMode(e:Event):void {
	     sendNotification(Notifications.COMPONENT_NORMAL_MODE,null);

	  }
	  
	  private function toolDone(e:Event):void {
	  	sendNotification(Notifications.HOTDRAW_TOOLDONE);
	  }
	  
	  
	  private function componentSendBack(e:Event):void {
	   var c:ComponentProxyFigure = (hotDrawApp.view() as GloDrawingView).layerComponent;
	  	sendNotification(Notifications.COMPONENT_SENDBACK,c);
	  }
	  
	  private function componentBringFront(e:Event):void {
	   var c:ComponentProxyFigure = (hotDrawApp.view() as GloDrawingView).layerComponent;
	   sendNotification(Notifications.COMPONENT_BRINGFRONT,c);
	  }

	         /**
     * Handles a change of the current selection. Updates all
     * menu items that are selection sensitive.
     * @see DrawingEditor
     */
     
    private function selectionChanged(e:Event):void {
    	// Send a notification if there is a single figured selected otherwise send a deselect notification
     	if(hotDrawApp.view().selection().size() == 1)
    	 sendNotification(Notifications.HOTDRAW_FIGURESELECTED,hotDrawApp.view().selection().elementAt(0));
    	else
    	 sendNotification(Notifications.HOTDRAW_CLEARSELECTION);
   }
	  
		
		
	}
}