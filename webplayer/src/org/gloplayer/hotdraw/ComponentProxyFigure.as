package org.gloplayer.hotdraw
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.modules.IModuleInfo;
	import mx.modules.ModuleManager;
	
	import org.gloplayer.data.ComponentInstanceVO;
	import org.gloplayer.utils.FigureSerialiser;

	public class ComponentProxyFigure extends UIComponent
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
		public static const COMPONENT_COMPLETE:String = "ComponentProxyFigure.ComponentComplete";


		/**
		 * Custom event - the component failed to instantiate. 
		 */
		public static const COMPONENT_FAILED:String = "ComponentProxyFigure.ComponentFailed";


		private var _componentInstance:ComponentInstanceVO;
		
		private var moduleInfo:IModuleInfo;
		private var child:UIComponent;
		
		/**
		 * Constructor 
		 * @param vo
		 */		
		public function ComponentProxyFigure(component:ComponentInstanceVO)
		{
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
				trace("Edit mode on", this);
				
				// now in edit mode
				mouseEnabled = false;
				mouseChildren = true;
				
				child.mouseEnabled = false;
				child.mouseChildren = true;
			}else{
				
				trace("edit mode off", this);
				
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
			// components are modules, so we use ModuleManager to obtain an instance
		    moduleInfo = ModuleManager.getModule(_componentInstance.component.swfNativePath); // use file.url to enable AIR module loading
	 	   // add event listener before calling 'load()' - if the module was previously loaded, the event listener will fire immediately
			moduleInfo.addEventListener(ModuleEvent.READY, onModuleReady);
			// load in the module
			moduleInfo.load(ApplicationDomain.currentDomain);
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
			child.addEventListener(FlexEvent.CREATION_COMPLETE, onChildCreationComplete);
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
			
			// successfully created component
			dispatchEvent(new Event(COMPONENT_COMPLETE));
					
			// <=== [Ref:3X5ZY, Musbah, 02-04-2009]
			// the settings of the figure can appied now 
		 	var helper:FigureSerialiser = new FigureSerialiser(this);
			helper.applyComponentSettings();
			// done
	
		}
		
		
	}
}