/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.common.data.serialiser
{
	import org.glomaker.common.interfaces.ISerialiser;
	import org.glomaker.interfaces.pattern.IPatternNode;
	import org.glomaker.interfaces.pattern.PatternNode;
	import org.glomaker.patternmaker.data.GlobalPoint;
	
	/**
	 * Utility method to serialise/deserialise an IPatternNode instance.  
	 * @author Nils
	 */	
	public class NodeSerialiser implements ISerialiser
	{

		public function serialise(object:Object):XML
		{
			var node:IPatternNode = object as IPatternNode;
			if(!node)	throw new Error("Object to serialise must be IPatternNode.");
			
			// serialise	
			var out:XML = <node>
							<id>{node.id}</id>
							<funcid>{node.func.id}</funcid>
							<title>{node.title}</title>
							<description>{node.description}</description>
							<locx>{node.loc.x}</locx>
							<locy>{node.loc.y}</locy>
							<parentid>{node.parentId}</parentid>
							<childid>{node.childId}</childid>
							<layoutid>{node.layoutId}</layoutid>
							<isroot>{node.isRoot}</isroot>
						  </node>;
						  
			/* never serialised - they are just utility properties used by patternMaker
				<isactive>{node.isActive}</isactive>
				<isreceiver>{node.isReceiver}</isreceiver>
			*/
			
			// done
			return out;
		}
		
		/**
		 * @param source
		 * @return An IPatternNode instance deserialised from the XML object provided.
		 * The node's function property is left as null - you will need to assign it manually.  
		 */		
		public function deserialise(source:XML):Object
		{
			var node:PatternNode = new PatternNode();

			if(source.hasOwnProperty("locx") && source.hasOwnProperty("locy"))
				node.loc = new GlobalPoint(source.locx, source.locy);
			
 			node.id = readString(source, "id");
 			node.title = readString(source, "title");
 			node.description = readString(source, "description");
 			node.parentId = readString(source, "parentid");
 			node.childId = readString(source, "childid");
 			node.layoutId = readString(source, "layoutid");
			node.isRoot = readBoolean(source, "isroot");
			
			// patternmaker utility properties
 			node.isActive = false;
 			node.isReceiver = false;

			// note: the function property can not be assigned here
			
			// done
			return node;
		}


		// ------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------
		
		/**
		 * Reads a string value from the XML.
		 * Checks for property existence and returns a "null" string as the real null value. 
		 * @param source
		 * @param name
		 * @return 
		 */		
		protected function readString(source:XML, name:String):String
		{
			var value:String;
			if(source.hasOwnProperty(name))
			{
				value = source.child(name);
				if(value == "null")
					value = null;
			}
			return value;
		}
		
		
		/**
		 * Reads a uint value from the XML.
		 * Checks the property exists and parses its value to a uint.
		 * Returns 0 if the property doesn't exist.
		 * @param source
		 * @param name
		 * @return 
		 */		
		protected function readUInt(source:XML, name:String):uint
		{
			var value:uint = 0;
			if(source.hasOwnProperty(name))
			{
				value = parseInt(String(source.child(name)));
			}
			return value;
		}
		
		
		/**
		 * Reads a boolean value from the XML.
		 * Checks the property exists and reads it in as a string. "true" is interpreted as Boolean true, all other values return Boolean false. 
		 * @param source
		 * @param name
		 * @return 
		 */		
		protected function readBoolean(source:XML, name:String):Boolean
		{
			var value:Boolean = false;
			if(source.hasOwnProperty(name))
			{
				value = (source.child(name) == "true");
			}
			return value;
		}
		
	}
}