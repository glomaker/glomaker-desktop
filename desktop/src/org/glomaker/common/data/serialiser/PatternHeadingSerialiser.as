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
	import org.glomaker.interfaces.pattern.IPatternHeading;
	import org.glomaker.interfaces.pattern.PatternHeading;
	
	public class PatternHeadingSerialiser implements ISerialiser
	{

		/**
		 * Serialises an IPatternHeading instance to XML. 
		 * @param object
		 * @return 
		 */
		public function serialise(object:Object):XML
		{
			var item:IPatternHeading = object as IPatternHeading;
			if(!item)	throw new Error("Object to serialise must be IPatternHeading.");

			// serialise
			var out:XML = <heading/>;
			
			out.@id = item.id;
			out.@title = item.title;
			out.@colour = item.colour;
			
			// process sub-entries
			var func:IPatternFunction;
			var funcSerialiser:ISerialiser = new NodeSerialiser();
			
			for each(func in item.functions)
			{
				out.appendChild(funcSerialiser.serialise(func));
			}

			// done
			return out;
		}
		
		
		/**
		 * Deserialises XML to a IPatternHeading instance.
		 * @param source
		 * @return IPatternHeading instance.
		 */		
		public function deserialise(source:XML):Object
		{
			var heading:IPatternHeading = new PatternHeading();
			
			// attributes
			heading.id = source.@id;
			heading.title = source.@title;
			heading.colour = parseInt(source.@colour);

			// functions defined for this heading
			var funcXML:XML;
			var func:IPatternFunction;
			var funcSerialiser:ISerialiser = new PatternFunctionSerialiser();
			var funcList:Array = [];
			
			for each(funcXML in source.func)
			{
				func = funcSerialiser.deserialise(funcXML) as IPatternFunction;
				func.heading = heading;
				funcList.push(func);
			}
			
			heading.functions = funcList;
			
			// done
			return heading;
		}
		
	}
}