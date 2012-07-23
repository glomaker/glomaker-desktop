/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.ui
{
  import flash.events.Event;
  
  import mx.controls.TextArea;
  import mx.events.FlexEvent;
 
  /**
   * Custom TextArea component that resizes vertically to fit, rather than show scrollbars. 
   * @author Nils
   */ 
  public class DynamicTextArea extends TextArea
  {
  	
    public function DynamicTextArea(){
      super();
      horizontalScrollPolicy = "off";
      verticalScrollPolicy = "off";
      
      addEventListener(Event.CHANGE, adjustHeightHandler, false, 0, false);
      addEventListener("textChanged", adjustHeightHandler, false, 0, false);
      addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler, false, 0, false);
    }
    
    
    override public function setStyle(styleProp:String, newValue:*):void
    {
    	super.setStyle(styleProp, newValue);
    	adjustHeightHandler();
    }


	private function creationCompleteHandler( evt:Event ):void
	{
		removeEventListener(FlexEvent.CREATION_COMPLETE, adjustHeightHandler);
		textField.mouseWheelEnabled = false;
	}

    private function adjustHeightHandler(event:Event = null):void
    {
    	if(textField)
    	{
      		super.height = calcRequiredHeight();
      		validateNow();
     	}
    }
    
    override public function set height(value:Number):void{
      
      // if height set before creationComplete
      if(textField == null)
      {
          super.height = value;
          
      }else{
      	
        super.height = calcRequiredHeight();
        
        // text area has a funny way of scrolling text around to make room for next line
        // we override this behaviour
        textField.scrollV = 0;
      }
    }
    
    override public function set width(value:Number):void
    {
    	super.width = value;
    	callLater(adjustHeightHandler);
    }
    
    
    override public function setActualSize(w:Number, h:Number):void
    {
    	super.setActualSize(w, h);
    	callLater(adjustHeightHandler);
    }
    
    protected function calcRequiredHeight():Number
    {
    	// if the width is zero, then the textfield will resize to display 1 character per line
    	// this usually happens when the textarea is initialised with a percentage width
		// to avoid the textfield from flashing up at a huge height, we simply treat this as a special case
 
    	if(!textField || getExplicitOrMeasuredWidth() == 0)
    	{
    		if(minHeight)
    			return minHeight;
    		else
    			return 0;
    	}

		// looks like we have reliable measurements    	
    	var requiredHeight:Number = textField.numLines * textField.getLineMetrics(0).height + 4;
    	return Math.max( minHeight, Math.min( maxHeight, requiredHeight ));
    }

  }
}
 