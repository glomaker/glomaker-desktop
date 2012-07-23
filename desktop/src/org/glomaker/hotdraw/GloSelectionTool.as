/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw
{
	import com.hotdraw.CH.ifa.draw.framework.DrawingView;
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	import com.hotdraw.CH.ifa.draw.framework.Handle;
	import com.hotdraw.CH.ifa.draw.standard.DeleteFigureCommand;
	import com.hotdraw.CH.ifa.draw.standard.SelectionTool;
	import com.hotdraw.CH.ifa.draw.util.Command;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import org.glomaker.hotdraw.controls.DeleteHandle;
	import org.glomaker.hotdraw.controls.EditHandle;
	import org.glomaker.hotdraw.controls.MoveBackwardsHandle;
	import org.glomaker.hotdraw.controls.MoveForwardsHandle;

	public class GloSelectionTool extends SelectionTool
	{
		public function GloSelectionTool(view:DrawingView)
		{
			super(view);
		}
		
       override public function mouseUp(e:MouseEvent, x:int, y:int):void {
       	super.mouseUp(e,x,y);
       	
       		var handle:Handle= view().findHandle(x,y);
       		if(handle == null) return; 
       		
       		var figure:Figure = handle.ownerFigure();
       		var display:Canvas = view() as Canvas;

       		if(handle is DeleteHandle){
       	    var cmd:Command= new DeleteFigureCommand("Delete", view(),figure);
            cmd.execute();
       		} else if(handle is MoveForwardsHandle){
       			var count:int = display.getChildren().length;
       			view().drawing().bringToFront(figure);
       			GloDrawingView(view()).dispatchBringFrontComponentEvent(ComponentProxyFigure(figure));
       			//display.addChildAt(handle.ownerFigure() as UIComponent,count);
       		} else if(handle is MoveBackwardsHandle){
       			view().drawing().sendToBack(figure);
       			GloDrawingView(view()).dispatchSendBackComponentEvent(ComponentProxyFigure(figure));
       			//display.addChildAt(handle.ownerFigure() as UIComponent,0);
       		} else if(handle is EditHandle){
       			var comp:ComponentProxyFigure = ComponentProxyFigure(figure);
       			GloDrawingView(view()).dispatchComponentEditModeEvent(comp);
       		} 
       	}
		
	}
}