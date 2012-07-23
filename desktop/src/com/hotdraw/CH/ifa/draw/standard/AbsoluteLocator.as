package com.hotdraw.CH.ifa.draw.standard
{
	import com.hotdraw.CH.ifa.draw.framework.Figure;
	import com.hotdraw.CH.ifa.draw.framework.Locator;
	import com.hotdraw.java.awt.geom._Point;
	import com.hotdraw.java.awt.geom._Rectangle;
	
	public class AbsoluteLocator extends AbstractLocator
	{
		
	 /*
     * Serialization support.
     */
    private static const serialVersionUID:Number= 26191488760878986028;
    private var relativeLocatorSerializedDataVersion:int= 1;

    private var fAbsoluteX:Number;
    private var fAbsoluteY:Number;

    public function AbsoluteLocator(x:Number= 0.0, y:Number= 0.0) {
         fAbsoluteX = x;
         fAbsoluteY = y;
    }

    override public function locate(owner:Figure):_Point {
        var r:_Rectangle= owner.displayBox();
        return new _Point(
            r.x + fAbsoluteX,
            r.y + fAbsoluteY
        );
    }
    
     /**
     * free.
     */
    static public function free(x:Number,y:Number):Locator {
        return new AbsoluteLocator(x, y);
    }

    
    
		
	}
}