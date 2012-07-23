package com.hotdraw.mouse {
	
/* 	This class solves the problem of mouse drag in Flex environment.
	It allows three types of mouse drag, (1) start drag, (2) end drag and (3) drag.
	For this method to be used, ... the class should be initialized  in the main file of the application
	using InitMouseDrag() function and passing the systemManager as a parameter	
	The target object can be added mouse drag facilities by calling addMouseDragListener,.. the target
	mouse implement the MouseDragListener to work and have abilities to add evening (addEventListener)
 */	
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	
	public class MouseDrag	{
		     	
		private var target:UIComponent = null;
		private var mouseHandler:MouseDragListener = null;
		
		private var startDragX:int=0;
		private var startDragY:int=0;
		// dragMode is true when the mouse is being dragged
		private var dragMode:Boolean=false;
		// startDrag is true when the mouse has just started the drag mode
		private var startDrag:Boolean=false;
		private static var systemManager:ISystemManager;
		
		
		public function MouseDrag(t:*,mh:*){
			target = t;
			mouseHandler = mh;
						 
			(target as UIComponent).addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);    
		    systemManager.addEventListener(MouseEvent.MOUSE_UP,systemManagerMouseUp);    
		    systemManager.addEventListener(MouseEvent.MOUSE_MOVE,systemManagerMouseMove);
		}
		
		// targetObject should be UIComponent
		// mouseHandler must implement MouseDragListener interface, 
		// if mouseHandler is null, then the targetObject should implement MouseDragListener interface
		public static function addMouseDragListener(targetObject:UIComponent,mouseHandler:MouseDragListener = null):void{
			
			if(mouseHandler == null)
			 mouseHandler = targetObject as MouseDragListener;
			 
			if(!(mouseHandler is MouseDragListener)) {
			 throw new Error("MouseDrag- Target does not implment MouseDragListener interface!");
			return;
			}
			
			new MouseDrag(targetObject,mouseHandler);
		} 
	    
	    public static function initMouseDrag(sm:ISystemManager):void{
	    	systemManager = sm;
	    }
	    
	    public function mouseDown(e:MouseEvent):void{
			 startDragX = e.localX;
			 startDragY = e.localY;
			 dragMode=true;
			 startDrag=true;
			}
			
			public function systemManagerMouseUp(e:MouseEvent):void{
			 if(dragMode){
			 dragMode=false;
			 // End Drag
			 mouseHandler.mouseEndDrag(e,(e.stageX-startDragX),(e.stageY-startDragY));
			 }
			}
			
			public function systemManagerMouseMove(e:MouseEvent):void{
			 if(dragMode){
			 	if(startDrag){
			 		startDrag = false;
			 		// Start Drag
			 		mouseHandler.mouseStartDrag(e,(e.stageX-startDragX),(e.stageY-startDragY));
			 	}
			 	// Drag Mode
			 	mouseHandler.mouseDrag(e,(e.stageX-startDragX),(e.stageY-startDragY));
			 }
			}
			
	}
}