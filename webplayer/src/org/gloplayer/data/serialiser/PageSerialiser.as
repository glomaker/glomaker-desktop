package org.gloplayer.data.serialiser
{
	import org.gloplayer.data.PageVO;
	
	public class PageSerialiser implements ISerialiser
	{
		public function serialise(object:Object):XML
		{
			var page:PageVO = object as PageVO;
			if(!page)	throw new Error("Object to serialise must be PageVO.");			
			
			// serialise
			var out:XML = <layout/>;
			out.@id = page.id;

			// done
			return out;
		}
		
		/**
		 * @param source
		 * @return Returns the page layout ID property (:String) 
		 */		
		public function deserialise(source:XML):Object
		{
			return String(source.@id);
		}
		
	}
}