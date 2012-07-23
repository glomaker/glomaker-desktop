/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw{
	import com.hotdraw.CH.ifa.draw.framework.DrawingEditor;
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	import com.hotdraw.CH.ifa.draw.standard.StandardDrawingView;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;

	public class GloDrawingView extends StandardDrawingView
	{
		// Holds the last figure that was double clicked
		public var lastDblClickedFigure:ComponentProxyFigure = null;
		
		// Holds the component selected to change layer (send back/ bring front)
		public var layerComponent:ComponentProxyFigure = null;

		 
		public function GloDrawingView(editor:DrawingEditor, dvCanvas:Canvas)
		{
			super(editor,dvCanvas);
			
			// Add double click mouse event to actvate mouse events on the component
     	   	dvCanvas.doubleClickEnabled = true;
     	    dvCanvas.addEventListener(MouseEvent.DOUBLE_CLICK,dblClick, false, 0, true);
     	    dvCanvas.addEventListener(MouseEvent.CLICK,click, false, 0, true);
		}
		
	 /**
     * Handles double click mouse event
     */
       // double click on the component should set it into edit mode
       public function dblClick(e:MouseEvent):void {
       	
     	 var p:Point = globalToLocal(new Point(e.stageX, e.stageY));
     	 
     	 // findFigure expects integer x, y values - using Math.round to provide them
     	 // this makes the process a little less accurate but only by at most 0.5 pixels
    	 var comp:ComponentProxyFigure = ComponentProxyFigure(drawing().findFigure(Math.round(p.x),Math.round(p.y)));
    	 
          dispatchComponentEditModeEvent(comp);
    }
    
    public function dispatchComponentEditModeEvent(comp:ComponentProxyFigure):void{
    	
    	// If the component does not have edit mode then don't don't proceed
    	if(comp == null || !IComponentPlugin(comp.getContent()).hasEditMode())
    	  return;
    	
	 	if(!comp.isEditMode()){
	 		// Set to edit mode
	    	clearSelection();
	 	    // set the edit mode of the last component to false
    		setEditMode(false);
    		lastDblClickedFigure = comp;
			setEditMode(true);
			dispatchEvent(new Event(HotDrawApplication.COMPONENTEDITMODE));
	 	}
    }
    
     public function dispatchSendBackComponentEvent(comp:ComponentProxyFigure):void{
     	layerComponent = comp;
     	dispatchEvent(new Event(HotDrawApplication.COMPONENTSENDBACK));
     }
     
     public function dispatchBringFrontComponentEvent(comp:ComponentProxyFigure):void{
     	layerComponent = comp;
     	dispatchEvent(new Event(HotDrawApplication.COMPONENTBRINGFRONT));
     }
     
     // a click off the figure should revert to none edit mode
     public function click(e:MouseEvent):void {
     	      selectionChanged(); 
    }
    
     // Set the figure into edit mode (or not)
     private function setEditMode(b:Boolean):void {
     	 if(lastDblClickedFigure) {
     	  lastDblClickedFigure.setEditMode(b);
          // Set the edit mode of the component!
     	  (lastDblClickedFigure.getContent() as IComponentPlugin).setEditMode(b); 	  					
     	 }
    }
    
      /**
     * Handles key down events. Cursor keys are handled
     * by the view the other key events are delegated to the
     * currently active tool.
     * @return whether the event was handled.
     */
     override public function keyPressed(e:KeyboardEvent):void {
     	// Don't precess keyboard events when in edit mode
     	if(!(lastDblClickedFigure && lastDblClickedFigure.isEditMode()))
     	 super.keyPressed(e);
     }
     
    /**
     * Informs that the current selection changed.
     * By default this event is forwarded to the
     * drawing editor.
     */
    override protected function selectionChanged():void
    {
		// get mouse coordinates
     	var p:Point = globalToLocal(new Point(stage.mouseX, stage.mouseY));

	    // find the figure that was clicked on
     	 // findFigure expects integer x, y values - using Math.round to provide them
     	 // this makes the process a little less accurate but only by at most 0.5 pixels
     	var fig:ComponentProxyFigure = drawing().findFigure(Math.round(p.x), Math.round(p.y)) as ComponentProxyFigure;

		// if no figure is selected now or we just clicked away from a figure being edited
		if( fig == null )
		{
			if( lastDblClickedFigure && lastDblClickedFigure.isEditMode() )
			{
				setEditMode( false );
				lastDblClickedFigure = null;
				
				// move focus to the entire drawing view
				// this removes the focus from the figure itself
				// see Issue 173
				setFocus();
				
				//
				dispatchEvent(new Event(HotDrawApplication.COMPONENTNORMALMODE));
			}
			
			super.selectionChanged();
			return;
		}

		// a figure was clicked on
		
		// if the figure was already selected and in edit mode, ignore the click
		if( fig == lastDblClickedFigure && fig.isEditMode() )
		{
			return;
		}
		
		// the figure wasn't already selected and in edit mode
		// options 1: fig != lastDblClickedFigure
		// option 2: fig == lastDblClickedFigure && !fig.isEditMode()
		
		if( fig == lastDblClickedFigure )
		{
			// user simply clicked again on an already selected figure
			// ignore the click
			return;
			
		}else{
			
			// user clicked away from a previously selected figure
			// that figure may have been in edit mode
			
			if( lastDblClickedFigure && lastDblClickedFigure.isEditMode() )
			{
				setEditMode( false );
				lastDblClickedFigure = null; 
				dispatchEvent(new Event(HotDrawApplication.COMPONENTNORMALMODE));				
			}
			
			// set mouse/keyboard focus on to this figure
			// see Issue 173
			fig.setFocus();
			
			// that means the selection has now changed (a new figure is selected)
			super.selectionChanged();
		}
     	
    }

      

}
}