/*
 * @(#)DrawingEditor.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.framework {

/**
 * DrawingEditor defines the interface for coordinating
 * the different objects that participate in a drawing editor.
 *
 * <hr>
 * <b>Design Patterns</b><P>
 * <img src="images/red-ball-small.gif" width=6 height=6 alt=" o ">
 * <b><a href=../pattlets/sld022.htm>Mediator</a></b><br>
 * DrawingEditor is the mediator. It decouples the participants
 * of a drawing editor.
 *
 * @see Tool
 * @see DrawingView
 * @see Drawing
 */
public interface DrawingEditor {

    /**
     * Gets the editor's drawing view.
     */
     function view():DrawingView ;
 
    /**
     * Gets the editor's drawing.
     */
     function drawing():Drawing ;
 
    /**
     * Gets the editor's current tool.
     */
     
       function tool():Tool ;
   
    /**
     * Informs the editor that a tool has done its interaction.
     * This method can be used to switch back to the default tool.
     */
     function toolDone():void ;
 
    /**
     * Informs that the current selection has changed.
     * Override this method to handle selection changes.
     */
    function selectionChanged(view:DrawingView):void ;
 
    /**
     * Shows a status message in the editor's user interface
     */
/*     function showStatus(string:String):void ;
 */
}
}