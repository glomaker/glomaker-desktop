/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.vo
{
	import org.glomaker.common.interfaces.IValueObject;
	import org.glomaker.interfaces.pattern.IPatternNode;
	
	
	public class PageInstanceVO implements IValueObject	{
		
		/**
		 * Pattern Maker Node
		 */		
		public var node:IPatternNode;

		/**
		 * Page definition 
		 */
		public var layout:PageVO;
		
		/**
		 * array of ComponentInstanceVO instances 
		 */	
		 
		private var _componentList:Array;

		/**
		 * Constructor 
		 * @param page
		 * @param rawPropXML
		 * @param w the width of the stage
		 * @param h the height of the stage
		 */		
		 
		public function PageInstanceVO(layout:PageVO,node:IPatternNode,w:Number,h:Number)	{
			this.node = node;
			setPageLayout(layout,w,h);
		}
	
		/**
		 * 
		 * @param newLayout
		 * @param w  the width of the stage
		 * @param h the height of the stage
		 * 
		 */		 		
		
		public function setPageLayout(newLayout:PageVO,w:Number,h:Number):void{
			this.layout = newLayout;
			var instance:ComponentInstanceVO;
			var instanceCopy :ComponentInstanceVO;
			// Copy components from PageVO
			_componentList = [];

			for each(instance in newLayout.components){
				instanceCopy = ComponentInstanceVO(instance.clone());
				// convert to xml
			    var xml:XML = new XML(instanceCopy.rawPropXML);
			    // Locate/Resize the components into the stage size
			    xml.@x = String(w * Number(xml.@x));
			    xml.@y = String(h * Number(xml.@y));
			    xml.@width = String(w * Number(xml.@width));
			    xml.@height = String(h * Number(xml.@height));
                instanceCopy.rawPropXML = xml.toXMLString();
			    _componentList.push(instanceCopy);
			}

		}
		
		/**
		 * Add a component to the page.
		 * Internally the function arguments are stored in a new ComponentInstanceVO instance.
		 * @param comp
		 * @param rawXML
		 * @return The newly created ComponentInstanceVO instance used to store the component data.
		 */		
		public function addComponent(comp:ComponentVO, rawXML:String,index:int = -1):ComponentInstanceVO
		{
			// create compound object
			var def:ComponentInstanceVO = new ComponentInstanceVO(comp, rawXML);
			
			// store 
			addComponentInstance(def);
			
			// done
			return def;
		}
		
		
		/**
		 * Checks whether a specific component instance is present on this page. 
		 * @param instance
		 * @return 
		 */		
		public function containsComponentInstance(instance:ComponentInstanceVO):Boolean
		{
			return (_componentList.indexOf(instance) > -1);
		}
		
		
		/**
		 * Add a component instance to the page. 
		 * @param instance
		 * @param index -1 to add to the end, alternatively specify a particular index
		 */
		public function addComponentInstance(instance:ComponentInstanceVO, index:int = -1):void
		{
			if(index == -1)
				_componentList.push(instance);
			else
				_componentList.splice(index, 0, instance);
		}
		
	    /**
		 * Remove a component to the page.
		 * @author musbah
		 * 
		 */
	   public function removeComponent(def:ComponentInstanceVO):void
		{
			var index:int = _componentList.indexOf(def);
			
			if(index > -1)
				_componentList.splice(index, 1);
		}
		
		/**
		 * Removes all components from the current page (resulting in a blank page). 
		 */		
		public function removeAllComponents():void
		{
			_componentList = [];
		}
		
		/**
		 * Return the components defined on this page. 
		 * @return An Array of data.ComponentInstanceVO instances.
		 */		
		public function get components():Array
		{
			return _componentList;
		}
		
		/**
		 * Return PatternMaker node associated with this page. 
		 * @return 
		 */		
		public function getNode():IPatternNode
		{
			return node;
		}
		
		 
		/**
		 * Return the title of the page (is title the right name?!) 
		 * 
		 */		
		[Bindable]
		public function get title():String
		{
			if(node)
			 return node.title;
			 
		 return layout.name;
		}
		public function set title(value:String):void
		{
			// not implemented - only present so Bindings will function correctly
		}

		/**
		 * Return the colour
		 */		
		[Bindable]
		public function get colour():uint
		{
			if(node)
			 return node.func.heading.colour;
			 
		 return 0xffffff;
		}
		public function set colour(value:uint):void
		{
			// not implemented - only present so Bindings will function correctly
		}
		
	}
}