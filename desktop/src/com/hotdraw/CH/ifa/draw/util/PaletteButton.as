/*
 * @(#)PaletteButton.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.util {

import flash.display.Graphics;
import flash.events.MouseEvent;
import mx.containers.Canvas;


/**
 * A palette button is a three state button. The states are normal
 * pressed and selected. It uses to the palette listener interface
 * to notify about state changes.
 *
 * @see PaletteListener
 * @see PaletteLayout
*/

public class PaletteButton extends Canvas{

    private static var NORMAL:int= 1;
    private static var PRESSED:int= 2;
    private static var SELECTED:int= 3;

    private var fListener:PaletteListener;
    private var fState:int;
    private var fOldState:int;


    /**
     * Constructs a PaletteButton.
     * @param listener the listener to be notified.
     */
    public function PaletteButton(listener:PaletteListener) {
    	
    	fState = fOldState = NORMAL;
   	
   	    this.addEventListener(MouseEvent.MOUSE_DOWN,mousePressed);
    	this.addEventListener(MouseEvent.MOUSE_UP,mouseReleased);
    	this.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoved);
    	this.addEventListener(MouseEvent.MOUSE_OUT,mouseExited);
        
        fListener = listener;
         
    }
    
   public function mousePressed(e:MouseEvent):void {
        fOldState = fState;
        fState = PRESSED;
        repaint(); 
    }

    public function mouseReleased(e:MouseEvent):void {
        fState = fOldState;
        repaint();

         if (hitTestPoint(e.stageX,e.stageY)){
         	 fListener.paletteUserSelected(this);
         }
    }

    public function mouseMoved(e:MouseEvent):void {
         fListener.paletteUserOver(this, true);
     }

    public function mouseExited(e:MouseEvent):void {
        fListener.paletteUserOver(this, false); 
    }
    
    public function paintBackground():void {;}
    public function paintNormal():void {;}
    public function paintPressed():void {;}
    public function paintSelected():void {;} 

    public function value():Object {
        return null;
    }
 
    public function reset():void {
         fState = NORMAL;
        repaint(); 
    }
    
   public function select():void {
        fState = SELECTED;
        repaint();
    }

     public function update():void {
         paint();
     }
 
    public function repaint():void {
    	paint();
    }
    
    public function paint():void {
        paintBackground();

        switch (fState) {
        case PRESSED:
            paintPressed();
            break;
        case SELECTED:
            paintSelected();
            break;
        case NORMAL:
        default:
            paintNormal();
            break;
        } 
    } 
    
}
}