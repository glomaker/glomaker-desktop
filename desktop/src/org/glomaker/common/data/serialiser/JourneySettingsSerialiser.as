/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data.serialiser
{
	import org.glomaker.common.data.JourneySettingsVO;
	import org.glomaker.common.interfaces.ISerialiser;
	
	/**
	 * Utility class to serialise/deserialise journey settings.  
	 * 
	 * @author Haykel
	 */	
	public class JourneySettingsSerialiser implements ISerialiser
	{

		public function serialise(object:Object):XML
		{
			var settings:JourneySettingsVO = object as JourneySettingsVO;
			if (!settings)
				throw new Error("Object to serialise must be JourneySettingsVO.");
			
			// serialise	
			var out:XML = <journey>
							<name>{settings.name}</name>
							<location>{settings.location}</location>
							<index>{settings.index}</index>
							<gps lat={settings.gpsLat} long={settings.gpsLong} enabled={settings.gpsEnabled ? "true" : "false"}></gps>
							<qr code={settings.qrCode} enabled={settings.qrEnabled ? "true" : "false"}></qr>
						  </journey>;
			
			// done
			return out;
		}
		
		/**
		 * @param source
		 * @return A JourneySettingsVO instance deserialised from the XML object provided.
		 */		
		public function deserialise(source:XML):Object
		{
			var settings:JourneySettingsVO = new JourneySettingsVO();

			settings.name = readString(source, "name");
			settings.location = readString(source, "location");
			settings.index = readUInt(source, "index");
			settings.gpsLat = readNumber(source, "gps", "lat");
			settings.gpsLong = readNumber(source, "gps", "long");
			settings.gpsEnabled = readBoolean(source, "gps", "enabled");
			settings.qrCode = readString(source, "qr", "code");
			settings.qrEnabled = readBoolean(source, "qr", "enabled");
			
			// done
			return settings;
		}


		// ------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------
		
		/**
		 * Reads the value of an element or an attribute of an element from XML.
		 */
		protected function readValue(source:XML, name:String, attribute:String=null):String
		{
			var value:String;
			
			if (source.hasOwnProperty(name))
			{
				var element:XML = source.child(name)[0];
				if (attribute)
				{
					if (element.hasOwnProperty("@" + attribute))
						value = element.attribute(attribute);
				}
				else
				{
					value = element;
				}
			}
			
			return value;
		}
		
		/**
		 * Reads a string value from the XML.
		 * Returns null if the property doesn't exist and for the "null" string. 
		 */		
		protected function readString(source:XML, name:String, attribute:String=null):String
		{
			var value:String = readValue(source, name, attribute);
			if (value == "null")
				value = null;
			
			return value;
		}
		
		/**
		 * Reads a uint value from the XML.
		 * Returns 0 if the property doesn't exist.
		 */		
		protected function readUInt(source:XML, name:String, attribute:String=null):uint
		{
			var value:String = readValue(source, name, attribute);
			
			return value ? parseInt(value) : 0;
		}
		
		/**
		 * Reads a float value from the XML.
		 * Returns NaN if the property doesn't exist.
		 */		
		protected function readNumber(source:XML, name:String, attribute:String=null):Number
		{
			var value:String = readValue(source, name, attribute);
			
			return value ? parseFloat(value) : NaN;
		}
		
		/**
		 * Reads a boolean value from the XML.
		 * Returns true for the "true" string and false for all other values. 
		 */		
		protected function readBoolean(source:XML, name:String, attribute:String=null):Boolean
		{
			var value:String = readValue(source, name, attribute);
			
			return value == "true";
		}
		
	}
}