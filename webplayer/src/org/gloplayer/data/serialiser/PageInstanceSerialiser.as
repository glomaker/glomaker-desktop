package org.gloplayer.data.serialiser
{
	import org.glomaker.data.ComponentInstanceVO;
	import org.glomaker.data.PageInstanceVO;

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