/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.vo
{
	import org.glomaker.common.interfaces.IClonable;
	import org.glomaker.common.interfaces.IValueObject;
	
	
	/**
	 * Describes a specific instance of a component.
	 * Stores the component's plugin ComponentVO instance alongside a raw string version of the property XML. 
	 * @author Nils
	 */	
	public class ComponentInstanceVO implements IValueObject, IClonable
	{
		
		/**
		 * Component definition 
		 */		
		public var component:ComponentVO;
		
		/**
		 * Raw properties XML string 
		 */		
		public var rawPropXML:String;

		
		/**
		 * Constructor 
		 * @param component
		 * @param rawPropXML [optional]
		 */		
		public function ComponentInstanceVO(component:ComponentVO, rawPropXML:String = null)
		{
			this.component = component;
			this.rawPropXML = rawPropXML;
		}


		/**
		 * Creates a copy of the object.
		 * NB: The component property is copied by reference, so the copy and the original will point to the same ComponentVO instance. 
		 * @return 
		 */
		public function clone():Object
		{
			// note: when cloning like this, component will be copied by reference, whereas rawPropXML is copied by value
			// this allows memory-efficient creation of new components
			// property XML can be changed on the clone without affecting the original instance
			// while both still point to the same ComponentVO 
			return new ComponentInstanceVO(component, rawPropXML);
		}
		
	}
}