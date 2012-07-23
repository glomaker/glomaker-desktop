package org.gloplayer.data.serialiser
{
	import org.glomaker.data.ComponentInstanceVO;
	import org.glomaker.data.ComponentVO;
	
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