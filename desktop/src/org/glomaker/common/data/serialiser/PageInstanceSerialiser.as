/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data.serialiser
{
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.common.vo.PageInstanceVO;

	/**
	 * Utility class that serialises and deserialises PageInstanceVO class instances. 
	 * @author Nils
	 */
	public class PageInstanceSerialiser implements ISerialiser
	{
		
		public function serialise(object:Object):XML
		{
			var instance:PageInstanceVO = object as PageInstanceVO;
			if(!instance)	throw new Error("Object to serialise must be PageInstanceVO.");
			
			// helper classes
			var nodeSerialiser:ISerialiser = new NodeSerialiser();
			var pageSerialiser:ISerialiser = new PageSerialiser();
			var compSerialiser:ISerialiser = new ComponentInstanceSerialiser();
			
			// serialise
			var out:XML = <page/>;
			
			out.appendChild(nodeSerialiser.serialise(instance.node));
			out.appendChild(pageSerialiser.serialise(instance.layout));
			
			for each(var comp:ComponentInstanceVO in instance.components)
			{
				out.appendChild(compSerialiser.serialise(comp));
			}
			
			// done
			return out;
		}
		
		public function deserialise(source:XML):Object
		{
			// not implemented - requires more complex process
			throw new Error("Not implemented for this class");
			return null;
		}
		
	}
}