/*
 * @(#)DrawApplication.java 5.1
 *
 */
package com.hotdraw.CH.ifa.draw.application {
import com.hotdraw.CH.ifa.draw.figures.*;
import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.standard.*;
import com.hotdraw.CH.ifa.draw.util.*;
import com.hotdraw.java.awt.*;
import com.hotdraw.java.awt.geom.Dimension;
import com.hotdraw.java.util.*;
import com.hotdraw.mouse.MouseDrag;

import flash.events.EventDispatcher;

import mx.containers.Canvas;
import mx.containers.VBox;
import mx.controls.Label;
import mx.managers.ISystemManager;
	

/**
 * DrawApplication defines a standard presentation for
 * standalone drawing editors. The presentation is
 * customized in subclasses.
 * The application is started as follows:
 * <pre>
 * public static void main(String[] args) {
 *     MayDrawApp window = new MyDrawApp();
 *     window.open();
 * }
 * </pre>
 */

public  class DrawApplication extends EventDispatcher implements DrawingEditor, PaletteListener {
    
    // The Canvas where the tools buttons are placed!		
	private var toolsCanvas:Canvas;
	// The Drawingview Canvas, where all figures are drawn
	private var drawingViewCanvas:Canvas;
	// The label to show the status
	private var fStatusLine:Label;
	
    private var fDrawing:Drawing;
    private var fTool:Tool;
    //private var fIconkit:Iconkit;

    //private var fStatusLine:TextField;
    private var fView:StandardDrawingView;
    private var fDefaultToolButton:ToolButton;
    private var fSelectedToolButton:ToolButton;

    private var fDrawingFilename:String;
    private static var fgUntitled:String= "untitled";

    // the image resource path
    private static  const fgDrawPath:String= "com/hotdraw/CH/ifa/draw/";
    public static  const IMAGES:String= fgDrawPath+"images/";
    
    /**
     * The index of the file menu in the menu bar.
     */
    public static const FILE_MENU:int= 0;
    /**
     * The index of the edit menu in the menu bar.
     */
    public static const EDIT_MENU:int= 1;
    /**
     * The index of the alignment menu in the menu bar.
     */
    public static const ALIGNMENT_MENU:int= 2;
    /**
     * The index of the attributes menu in the menu bar.
     */
    public static const ATTRIBUTES_MENU:int= 3;

    /**
     * Constructs a drawing window with a default title.
     */
    public function DrawApplication(sm:ISystemManager,dvc:Canvas,tc:Canvas = null,sl:Label = null){
			drawingViewCanvas = dvc;
			toolsCanvas = tc;
			fStatusLine = sl;
			// Initilize the mouse Drag handler! 
		    MouseDrag.initMouseDrag(sm);
		    
		    fView = createDrawingView(drawingViewCanvas);                               
            createTools(toolsCanvas);
            initDrawing();     
		}

    public function registerEvents():void{
   		StandardDrawingView(view()).registerEvents();
    }

    public function unregisterEvents():void{
   		StandardDrawingView(view()).unregisterEvents();
     }
 
    private function initDrawing():void {
        fDrawing = createDrawing();
        fDrawingFilename = fgUntitled;
        fView.setDrawing(fDrawing);
        toolDone();
    }

    /**
     * Creates the tools. By default only the selection tool is added.
     * Override this method to add additional tools.
     * Call the inherited method to include the selection tool.
     * @param palette the palette where the tools are added.
     */
    protected function createTools(palette:Canvas):void {
        var tool:Tool= createSelectionTool();
        fDefaultToolButton = createToolButton(IMAGES+"SEL", "Selection Tool", tool);
        
        if(palette){
          var vbox:VBox = (palette.getChildAt(0) as VBox);
          vbox.addChild(fDefaultToolButton)
        
          tool= new CreationTool(view(),new RectangleFigure());
          var fToolButton:ToolButton  = createToolButton(IMAGES+"RECT", "Rectangle Tool", tool);
          vbox.addChild(fToolButton)
        }
        
    }
    
    /**
     * Creates the selection tool used in this editor. Override to use
     * a custom selection tool.
     */
     public function createSelectionTool():Tool {
        return new SelectionTool(view());
    } 
    
    /**
     * Creates a tool button with the given image, tool, and text
     */
    protected function createToolButton(iconName:String, toolName:String, tool:Tool ):ToolButton {
        return new ToolButton(this, iconName, toolName, tool );
    }

    /**
     * Creates the drawing view used in this application.
     * You need to override this method to use a DrawingView
     * subclass in your application. By default a standard
     * DrawingView is returned.
     */
  public function createDrawingView(drawingViewCanvas:Canvas):StandardDrawingView {
   return new StandardDrawingView(this, drawingViewCanvas);
  }

    /**
     * Creates the drawing used in this application.
     * You need to override this method to use a Drawing
     * subclass in your application. By default a standard
     * Drawing is returned.
     */
    protected function createDrawing():Drawing {
        return new StandardDrawing();
    }

    /**
     * Sets the drawing to be edited.
     */
    public function setDrawing(drawing:Drawing):void {
        fView.setDrawing(drawing);
        fDrawing = drawing;
    }

    /**
     * Gets the default size of the window.
     */
    protected function defaultSize():Dimension {
        return new Dimension(430,406);
    }
 
    /**
     * Handles a user selection in the palette.
     * @see PaletteListener
     */
    public function paletteUserSelected(button:PaletteButton):void {
       var toolButton:ToolButton= ToolButton(button);
        setTool(toolButton.tool(), toolButton.getName());
        setSelected(toolButton);
     }

    /**
     * Handles when the mouse enters or leaves a palette button.
     * @see PaletteListener
     */
    public function paletteUserOver(button:PaletteButton, inside:Boolean):void {
        var toolButton:ToolButton= ToolButton(button);
        if (inside)
            showStatus(toolButton.getName());
         else
            showStatus(fSelectedToolButton.getName());
    }

    /**
     * Gets the current drawing.
     * @see DrawingEditor
     */
    public function drawing():Drawing {
        return fDrawing;
    }

    /**
     * Gets/sets the current tool.
     * @see DrawingEditor
     */
     public function tool():Tool {
        return fTool;
    } 
 
    /**
     * Gets the current drawing view.
     * @see DrawingEditor
     */
    public function view():DrawingView {
        return fView as DrawingView;
    }

    /**
     * Sets the default tool of the editor.
     * @see DrawingEditor
     */
    public function toolDone():void {
        if (fDefaultToolButton != null) {
            setTool(fDefaultToolButton.tool(), fDefaultToolButton.getName());
            setSelected(fDefaultToolButton);
        }
    } 

    /**
     * Shows a status message.
     * @see DrawingEditor
     */
    public function showStatus(string:String):void {
    	if(fStatusLine)
         fStatusLine.text = string;
    }

    public function setTool(t:Tool, name:String = null):void {
        if (fTool != null)
            fTool.deactivate();
        fTool = t;
        if (fTool != null) {
            showStatus(name);
            fTool.activate();
        }
    } 

     public function setSelected(button:ToolButton):void {
        if (fSelectedToolButton != null)
            fSelectedToolButton.reset();
        fSelectedToolButton = button;
        if (fSelectedToolButton != null)
            fSelectedToolButton.select();
    } 

    /**
     * Exits the application. You should never override this method
     */


    /**
     * Handles additional clean up operations. Override to destroy
     * or release drawing editor resources.
     */
    protected function destroy():void {
    }

    /**
     * Resets the drawing to a new empty drawing.
     */
    public function promptNew():void {
        initDrawing();
    }
    
    /**
     * Handles a change of the current selection. Updates all
     * menu items that are selection sensitive.
     * @see DrawingEditor
     */
    public function selectionChanged(view:DrawingView):void {
 
    }
   
}
}