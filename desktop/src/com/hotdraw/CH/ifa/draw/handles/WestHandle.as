package com.hotdraw.CH.ifa.draw.handles
{
		
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	import com.hotdraw.CH.ifa.draw.standard.LocatorHandle;
	import com.hotdraw.CH.ifa.draw.standard.RelativeLocator;
	
	import com.hotdraw.java.awt.geom._Point;
	import com.hotdraw.java.awt.geom._Rectangle;
	
	public class WestHandle extends LocatorHandle {
    public function WestHandle(owner:Figure) {
        super(owner, RelativeLocator.west());
    }

override public function invokeStep(m:int, n:int, o:*, p:*=null, q:*=null):void {
        var anchorX:int = o as int;
      	var anchorY:int = p as int;
      	
      	var r:_Rectangle= ownerFigure().displayBox();
        ownerFigure().displayBox(
            new _Point(Math.min(r.x + r.width, m), r.y),
            new _Point(r.x + r.width, r.y + r.height)
        );
    }
}
}