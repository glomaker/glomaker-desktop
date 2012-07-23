package org.gloplayer.data
{

	public class PageVO extends PluginInfoVO
	{

		// array of ComponentInstanceVO instances		
		private var _componentList:Array = [];
		
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
			if(index == -1)
			 _componentList.push(def);
			else
			 _componentList.splice(index,0,def);
			
			// done
			return def;
		}
		
		/**
		 * Adds a component instance if it doesn't already exist. 
		 * @return true if it was a new instance, false otherwise 
		 */		
		public function addComponentInstance(instance:ComponentInstanceVO):Boolean
		{
			if(_componentList.indexOf(instance) == -1)
			{
				_componentList.push(instance);
				return true;
			}
			
			// already in the list
			return false;
		}
		
	    /**
		 * Remove a component to the page.
		 * @author musbah
		 * 
		 */
	   public function removeComponent(def:ComponentInstanceVO):void
		{
			// Create a new array of components that does not include the deleted one
			// There is probably a better way of doing this!!!
			// yes, there is - see below :)
			
			var index:int = _componentList.indexOf(def);
			
			if(index > -1)
				_componentList.splice(index, 1);
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
		 * Override for abstract clone() method.
		**/
		override public function clone():Object
		{
			var vo:PageVO = new PageVO();
			
			// PluginInfoVO properties
			vo.author = author;
			vo.description = description;
			vo.glomakerVersion = glomakerVersion;
			vo.id = id;
			vo.name = name;
			//vo.pluginDirectory = pluginDirectory;
			//vo.pluginIcon = pluginIcon;
			vo.type = type;
			vo.version = version;
			
			// components
			var comp:ComponentInstanceVO;
			for each(comp in _componentList)
			{
				vo.addComponent(comp.component, comp.rawPropXML);
			} 
			
			// done
			return vo;
		}
		
	}
}