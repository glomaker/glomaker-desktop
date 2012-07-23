/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data.serialiser
{
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.common.vo.PageVO;
	
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