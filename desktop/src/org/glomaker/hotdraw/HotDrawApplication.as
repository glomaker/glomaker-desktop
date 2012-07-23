/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw
{
	import com.hotdraw.CH.ifa.draw.application.DrawApplication;
	import com.hotdraw.CH.ifa.draw.framework.DrawingView;
	import com.hotdraw.CH.ifa.draw.framework.Tool;
	import com.hotdraw.CH.ifa.draw.standard.StandardDrawingView;
	import com.hotdraw.CH.ifa.draw.standard.ToolButton;
	
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.managers.ISystemManager;
	
	public class HotDrawApplication extends DrawApplication
	{
		 private var fDefaultTool:Tool;
         private var fSelectedTool:Tool;
    
		 // Define events as static constants
         public static const COMPONENTEDITMODE:String = "HotDrawApplication.Component.Edit.Mode";
         public static const COMPONENTNORMALMODE:String = "HotDrawApplication.Component.Normal.Mode";
         public static const TOOLDONE:String = "HotDrawApplication.ToolDone";
         public static const STANDARDDRAWINGCANVASCREATED:String = "HotDrawApplication.StandardDrawingCanvasCreated";
         public static const SELECTIONCHANGED:String = "HotDrawApplication.selectionChanged";
         public static const COMPONENTSENDBACK:String = "HotDrawApplication.Component.Send.Back";
         public static const COMPONENTBRINGFRONT:String = "HotDrawApplication.Component.Bring.Front";

         
		public function HotDrawApplication(sm:ISystemManager,drawingViewCanvas:Canvas){
			super(sm,drawingViewCanvas);
		}
				        
         /**
     * Creates the tools. By default only the selection tool is added.
     * Override this method to add additional tools.
     * Call the inherited method to include the selection tool.
     * @param palette the palette where the tools are added.
     */
    override protected function createTools(palette:Canvas):void {
        var tool:Tool= createSelectionTool();
        fDefaultTool = tool;
    }
    
    
    /**
     * Sets the default tool of the editor.
     * @see DrawingEditor
     */
    override public function toolDone():void {
    	  if (fDefaultTool != null) {
            setTool(fDefaultTool);
            // There is no default tool button
            setSelected(null);
        }
        
    	
    }

     override public function setSelected(button:ToolButton):void {
      // Send this event to deselect all GLO component buttons
      dispatchEvent(new Event(TOOLDONE));
     }
     
     /**
     * Send an event when the selection of figures has changed, to handle a change of the current selection. 
     */
     
    override public function selectionChanged(v:DrawingView):void {
        dispatchEvent(new Event(SELECTIONCHANGED));
    }
    
    /**
     * Creates the drawing view used in this application.
     * You need to override this method to use a DrawingView
     * subclass in your application. By default a standard
     * DrawingView is returned.
     */
     override public function createDrawingView(drawingViewCanvas:Canvas):StandardDrawingView {
        return new GloDrawingView(this, drawingViewCanvas);
     }
     
     public function getGloDrawingView():GloDrawingView{
     	return GloDrawingView(view());
     }
     
        /**
     * Creates the selection tool used in this editor. Override to use
     * a custom selection tool.
     */
     override public function createSelectionTool():Tool {
        return new GloSelectionTool(view());
    } 
     

	}
}