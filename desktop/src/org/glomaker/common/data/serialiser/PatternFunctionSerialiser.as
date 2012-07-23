/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data.serialiser
{
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.interfaces.pattern.IPatternFunction;
	import org.glomaker.interfaces.pattern.IPatternGuidancePage;
	import org.glomaker.interfaces.pattern.PatternFunction;
	
	
	/**
	 * Utility method to serialise/deserialise an IPatternFunction instance.  
	 * @author Nils
	 */	
	public class PatternFunctionSerialiser implements ISerialiser
	{

		public function serialise(object:Object):XML
		{
			var func:IPatternFunction = object as IPatternFunction;
			if(!func)	throw new Error("Object to serialise must be IPatternFunction.");
			
			// serialise	
			var out:XML = <func>
							<id>{func.id}</id>
							<title>{func.title}</title>
							<description>{func.description}</description>
							<defaultLayoutId>{func.defaultLayoutId}</defaultLayoutId>
						  </func>;
						  
			// add guidance pages
			var guidanceXML:XML = <guidance/>;
			var guidanceSerialiser:ISerialiser = new GuidancePageSerialiser();
			var page:IPatternGuidancePage;
			
			for each(page in func.guidance)
			{
				guidanceXML.appendChild(guidanceSerialiser.serialise(page));
			}
			
			out.appendChild(guidanceXML);
			
			// done
			return out;
		}
		
		/**
		 * @param source
		 * @return An IPatternFunction instance deserialised from the XML object provided.
		 * The 'heading' property will be null - you will need to assign it manually.  
		 */		
		public function deserialise(source:XML):Object
		{
			var func:IPatternFunction = new PatternFunction();

			func.id = source.id;
			func.title = source.title;
			func.description = source.description;
			func.defaultLayoutId = source.defaultLayoutId;

			// add guidance
			var guidanceSerialiser:ISerialiser = new GuidancePageSerialiser();
			var pages:Array = [];
			var pageXML:XML;
			
			for each(pageXML in source.guidance.page)
			{
				pages.push(guidanceSerialiser.deserialise(pageXML));
			}
			
			func.guidance = pages;
			
			// done
			return func;
		}


		// ------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------
		
		
	}
}