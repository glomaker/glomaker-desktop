package com.hotdraw.CH.ifa.draw.handles
{
	
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	import com.hotdraw.CH.ifa.draw.standard.LocatorHandle;
	import com.hotdraw.CH.ifa.draw.standard.RelativeLocator;
	
	import com.hotdraw.java.awt.geom._Point;
	import com.hotdraw.java.awt.geom._Rectangle;
		
	public class EastHandle extends LocatorHandle {
    
    public function EastHandle(owner:Figure) {
        super(owner, RelativeLocator.east());
    }

  //override public function invokeStep(x:int, y:int, anchorX:int, anchorY:int, view:DrawingView):void {
    override public function invokeStep(m:int, n:int, o:*, p:*=null, q:*=null):void {
        var anchorX:int = o as int;
      	var anchorY:int = p as int;
      	
        var r:_Rectangle= ownerFigure().displayBox();
        ownerFigure().displayBox(
            new _Point(r.x, r.y), new _Point(Math.max(r.x, m), r.y + r.height)
        );
    }
}

}