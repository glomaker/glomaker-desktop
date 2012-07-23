/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import com.adobe.serialization.json.JSON;
	
	import org.glomaker.shared.properties.IComponentProperty;
	

	/**
	 * Library class providing static methods to serialise / deserialise an IComponentProperty instance. 
	 * @author Nils
	 */
	public class PropertySerialiser
	{

		protected static const CDATA_START:String = "<![CDATA[";
		protected static const CDATA_END:String = "]]>";
		

		public static function serialise(propValue:*, parentTag:XML):void
		{
			// use JSON to serialise
			parentTag.appendChild(JSON.encode(propValue));
		}
		
		/**
		 * Deserialise (using JSON) a property XML value. 
		 * @param propXML
		 * @return 
		 * @throws Error if the decode operation failed.
		 */		
		public static function deserialise(propXML:XML):*
		{
			// get first child - this stores the value of the property
			// eg. <text>Introduction to the Presentation</text>
			var stringValue:String = propXML.text().toString();
			
			var decoded:*;

			// decode using JSON
			decoded = JSON.decode(stringValue);
			
			// done
			return decoded;
		}
		
		/**
		 * Remove CDATA wrapper from a string (if it has one). 
		 * @param value
		 * @return 
		 * 
		 */		
		protected static function removeCDataWrapper(value:String):String
		{
				var start:String = CDATA_START;
				var end:String = CDATA_END;
				var result:String = value;
				
				if(value.slice(0, start.length) == start && value.slice(-end.length) == end)
				{
					result = value.slice(start.length, -end.length);
				}
				
				return result;
		}
	}
}