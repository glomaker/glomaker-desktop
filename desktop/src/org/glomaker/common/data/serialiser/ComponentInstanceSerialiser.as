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
	
	public class ComponentInstanceSerialiser implements ISerialiser
	{
		public function serialise(object:Object):XML
		{
			var comp:ComponentInstanceVO = object as ComponentInstanceVO;
			if(!comp)	throw new Error("Object to serialise must be ComponentInstanceVO.");
			
			return new XML(comp.rawPropXML);
		}
		
		public function deserialise(source:XML):Object
		{
			return null;
		}
		
	}
}