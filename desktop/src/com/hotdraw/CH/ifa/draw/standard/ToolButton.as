/*
 * @(#)ToolButton.java 5.1
 *
 */

package com.hotdraw.CH.ifa.draw.standard {

import com.hotdraw.CH.ifa.draw.framework.*;
import com.hotdraw.CH.ifa.draw.util.*;

import mx.controls.Image;



/**
 * A PaletteButton that is associated with a tool.
 * @see Tool
 */
public class ToolButton extends PaletteButton {
	
	private var im:Array;
    private var fName:String;
    private var fTool:Tool;

     public function ToolButton(listener:PaletteListener, iconName:String, name:String,tool:Tool) {
        super(listener);
      
        im = new Array();
        im[0] = loadImageResource(iconName+"1.gif");
        im[1] = loadImageResource(iconName+"2.gif");
        im[2] = loadImageResource(iconName+"3.gif");

        for (var i:int= 0; i < 3; i++) {
           addChild(im[i]);
        }
        
        showImage(0);
        
        this.width = 24;
        this.height = 24;
        
        fTool = tool;
        fName = name;
    }
    
     public function loadImageResource(filename:String):Image {
       var img:Image = new Image();
       img.load(filename);
       return img;
    }

    public function getName():String {
        return fName;
    }
    

    public function tool():Tool {
        return fTool;
    }

   

    public function attributeValue():Object {
        return tool();
    }
/*
    public function getMinimumSize():Dimension {
        return new Dimension(fIcon.getWidth(), fIcon.getHeight());
    }

    public function getPreferredSize():Dimension {
        return new Dimension(fIcon.getWidth(), fIcon.getHeight());
    }
*/
 
   public function showImage(n:int):void { 
    	var img:Image;
    	 for (var i:int= 0; i < 3; i++) {
           img = im[i];
           if(img!=null)
            img.visible = false;
        }
        img = im[n];
        if(img!=null)
         img.visible = true;
    }
    
    override public function paintBackground():void { ;}

    override public function paintNormal():void {
     showImage(0);
    }

    override public function paintPressed():void {
     showImage(1);
    }

    override public function paintSelected():void {
     showImage(2);
    } 

}
}