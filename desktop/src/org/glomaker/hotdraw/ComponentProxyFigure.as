/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.hotdraw
{
	import com.hotdraw.CH.ifa.draw.figures.RectangleFigure;
	import com.hotdraw.java.awt.geom._Point;
	import com.hotdraw.java.util._Vector;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.Capabilities;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import org.glomaker.app.utils.FigureSerialiser;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.hotdraw.controls.DeleteHandle;
	import org.glomaker.hotdraw.controls.EditHandle;
	import org.glomaker.hotdraw.controls.MoveBackwardsHandle;
	import org.glomaker.hotdraw.controls.MoveForwardsHandle;
	import org.glomaker.shared.component.interfaces.IComponentPlugin;

	public class ComponentProxyFigure extends RectangleFigure
	{
		
		/*
		* Glo components now have edit mode that can be enabled by mouse double click, 
		* ... to exit the edit mode, double click (or click) on the workspace or another component.
		* In edit mode the component does not move or resize.
		*/ 
		private var editMode:Boolean = false;

		/**
		 * Custom event - the component has been correctly instantiated. 
		 */
		public static const COMPONENT_COMPLETE:String = "PlayerComponentFigure.ComponentComplete";


		/**
		 * Custom event - the component failed to instantiate. 
		 */
		public static const COMPONENT_FAILED:String = "PlayerComponentFigure.ComponentFailed";


		private var _componentInstance:ComponentInstanceVO;
		
		private var moduleInfo:IModuleInfo;
		private var child:UIComponent;
		
		/**
		 * Constructor 
		 * @param vo
		 */		
		public function ComponentProxyFigure(component:ComponentInstanceVO)
		{
			// create at 0-size - will be updated correctly when drawn / module has loaded in
			super(new _Point(0,0), new _Point(0, 0));
			
			// save
			_componentInstance = component;
			
			// start loading module			
			loadComponentModule();
		}		
		
		
		// -----------------------------------------------------
		// PUBLIC METHODS
		// -----------------------------------------------------		
		
		
		/**
		 * Retrieve ComponentVO
		 * @return 
		 */		
		public function getComponentInstance():ComponentInstanceVO
		{
			return _componentInstance;
		}
		
		/**
		 * Check whether the figures content module has loaded. 
		 * @return 
		 */		
		public function hasLoadedContent():Boolean
		{
			return (child != null);
		}


		/**
		 * Retrieve the view component that this proxy is displaying.
		 * Note that since plugin components are modules, this instance is only valid once the COMPONENT_COMPLETE event has been dispatched.
		 * @return 
		 */		
		public function getContent():UIComponent
		{
			return child;
		}
		
		
		/**
		 * Switch the figure to 'edit' mode. 
		 * @param b
		 */		
		public function setEditMode(b:Boolean):void
		{
			editMode = b;
			if(!child)
			 return
			 
			//turn child mouse events on/off depends on edit mode
			if(b)
			{
				// now in edit mode
				mouseEnabled = false;
				mouseChildren = true;
				
				child.mouseEnabled = false;
				child.mouseChildren = true;
			}else{
				
				// not in edit mode anymore
	 			mouseEnabled = mouseChildren = false;
				child.mouseEnabled = child.mouseChildren = false;
			}
			
			// update focus rectangle
			child.drawFocus(b);
		}		
		
		
		public function isEditMode():Boolean{
			return editMode;
		}
		
		
		
		// -----------------------------------------------------
		// PROTECTED METHODS
		// -----------------------------------------------------		
		
		
		/**
		 * Load GLO component module from SWF (or cached module definition). 
		 */		
		protected function loadComponentModule():void
		{
			// little trick for allowing modules to be loaded from AIR or normal Flash player 
			var isAir : Boolean = (Capabilities.playerType == "Desktop");
			var moduleUrl:String = (isAir ? _componentInstance.component.swfAIRUrl : _componentInstance.component.swfNativePath);
			
			// components are modules, so we use ModuleManager to obtain an instance
			moduleInfo = ModuleManager.getModule(moduleUrl);
			
	 	   // add event listener before calling 'load()' - if the module was previously loaded, the event listener will fire immediately
			moduleInfo.addEventListener(ModuleEvent.READY, onModuleReady, false, 0, true);
			
			// load in the module
			moduleInfo.load();
		}
		
		
		/**
		 * Flex component override 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			// make sure component child is sized accordingly
			if(child)
			{
				child.width = width;
				child.height = height;
			}
		}
		
      /**
		 * Event handler - the component module is now available. 
		 * @param evt
		 */		
		protected function onModuleReady(evt:ModuleEvent):void
		{
			// remove event listener
			moduleInfo.removeEventListener(ModuleEvent.READY, onModuleReady);
			
			// create a new module instance
			child = moduleInfo.factory.create() as UIComponent;
			
			// if this step failed, the component is broken or incompatible
			if(child == null)
			{
				dispatchEvent(new Event(COMPONENT_FAILED));
				return;
			}
			
			// add to display list
			addChild(child);
			
			// module info not required anymore - clean memory
			moduleInfo = null;

			
			// apply width/height/percent width/percent height as defined by the child
			// the proxy simply acts as a pass-through wrapper, so should respect the child's definitions
			var cpw:Number = child.percentWidth;
			if(!isNaN(cpw))
				percentWidth = cpw;
				
			var cph:Number = child.percentHeight;
			if(!isNaN(cph))
				percentHeight = cph;
			
			var cw:Number = child.width;
			if(cw > 0)
				width = cw;
				
			var ch:Number = child.height;
			if(ch > 0)
				height = ch;	
			
			// listen for the child's creationComplete event - we use that one as the actual 'complete' trigger
			child.addEventListener(FlexEvent.CREATION_COMPLETE, onChildCreationComplete, false, 0, true);
		}
		
		
		/**
		 * Event handler - module instance's creationComplete event has fired. 
		 * @param evt
		 */		
		protected function onChildCreationComplete(evt:FlexEvent):void
		{
			// remove event listener again
			(evt.target as IEventDispatcher).removeEventListener(evt.type, onChildCreationComplete);

			// apply child position styles
			// these only become available 'onCreationComplete'
			// the proxy simply acts as a pass-through wrapper, so should respect the child's definitions
			var child:Object = evt.target;

			setStyle("top", child.getStyle("top"));
			setStyle("bottom", child.getStyle("bottom"));
			setStyle("left", child.getStyle("left"));
			setStyle("right", child.getStyle("right"));

			// wait one more frame before applying initial settings
			// data bindings set up by the component can cause mis-fires on style changes otherwise
			// see Issue 142
			callLater(runComponentInit);
		}
		
		/**
		 * Event handler - one frame has passed since creationComplete event. 
		 * @param evt
		 */		
		protected function runComponentInit():void
		{
			// <=== [Ref:3X5ZY, Musbah, 02-04-2009]
			// the settings of the figure can appied now
		 	var helper:FigureSerialiser = new FigureSerialiser(this);
			helper.applyComponentSettings();

			// done
			// successfully created component
			dispatchEvent(new Event(COMPONENT_COMPLETE));
		}
		
		
		override public function handles():_Vector{
			if(!editMode){
		     var handles:_Vector = super.handles();
	         handles.addElement(new DeleteHandle(this,0));
	         handles.addElement(new MoveForwardsHandle(this,1));
	         handles.addElement(new MoveBackwardsHandle(this,2));
           	 if(IComponentPlugin(getContent()).hasEditMode())
  	         	handles.addElement(new EditHandle(this,3));
	         return handles;
			}
		 return new _Vector();
		}

		override public function moveBy(dx:int, dy:int):void{
			if(!editMode)
			 super.moveBy(dx,dy); 
		}
		
	 	// Don't draw the parent!
		override public function draw(g:Graphics):void{
			
		} 
		
	}
}