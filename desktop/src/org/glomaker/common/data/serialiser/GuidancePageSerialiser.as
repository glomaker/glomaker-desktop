/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data.serialiser
{
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.interfaces.pattern.IPatternGuidancePage;
	import org.glomaker.interfaces.pattern.PatternGuidancePage;
	
	/**
	 * Utility method to serialise/deserialise an IPatternGuidancePage instance.  
	 * @author Nils
	 */	
	public class GuidancePageSerialiser implements ISerialiser
	{

		public function serialise(object:Object):XML
		{
			var page:IPatternGuidancePage = object as IPatternGuidancePage;
			if(!page)	throw new Error("Object to serialise must be IPatternGuidancePage.");
			
			// serialise	
			var out:XML = new XML("<page><![CDATA[" + page.htmlContent + "]]>");
			out.@title = page.title;
						  
			// done
			return out;
		}
			
		public function deserialise(source:XML):Object
		{
			var page:IPatternGuidancePage = new PatternGuidancePage();

			page.title = source.@title;
			page.htmlContent = source;

			// done
			return page;
		}
	}
}