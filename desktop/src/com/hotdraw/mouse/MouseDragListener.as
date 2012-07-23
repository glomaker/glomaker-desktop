package com.hotdraw.mouse {
	import flash.events.MouseEvent;
	
	public interface MouseDragListener{
		// Triger when the mouse start drag
		function mouseStartDrag(e:MouseEvent,x:int,y:int):void;
		// Triger when the mouse end drag
		function mouseEndDrag(e:MouseEvent,x:int,y:int):void;
		// Triger when the mouse is being dragged
		function mouseDrag(e:MouseEvent,x:int,y:int):void;
	}
}