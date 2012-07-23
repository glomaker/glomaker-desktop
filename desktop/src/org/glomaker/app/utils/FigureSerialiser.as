/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.utils
{
	import com.hotdraw.java.awt.geom._Point;
	
	import mx.controls.Alert;
	
	import org.glomaker.common.vo.ComponentInstanceVO;
	import org.glomaker.hotdraw.ComponentProxyFigure;
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.IComponentProperty;
	
	
	/**
	 * Creates an XML object to represent a ComponentProxyFigure instance. 
	 * @author Nils
	 */	
	public class FigureSerialiser
	{
		
		/**
		 * Figure this class is managing. 
		 */
		protected var _fig:ComponentProxyFigure;
		
		
		/**
		 * Constructor 
		 * @param fig
		 */		
		public function FigureSerialiser(fig:ComponentProxyFigure)
		{
			_fig = fig;
		}
		

		/**
		 * Create a raw properties XML object from the Figure. 
		 * @return 
		 */		
		protected function toXML():XML
		{
			var out:XML = <component/>;
			
			// component id
			out.@id = _fig.getComponentInstance().component.id;
			
			// figure properties (attribute() returns an XMLList)
			out.@x = _fig.x;
			out.@y = _fig.y;
			out.@width = _fig.width;
			out.@height = _fig.height;

			// component properties
			var comp:IComponentPlugin = _fig.getContent() as IComponentPlugin;
			
			if(comp)
			{
				saveComponentProperties(comp, out);
			}

			// done
			return out;
		}
		
		
		/**
		 * Save the Figure by updating the raw properties string of the component instance it's displaying. 
		 */		
		public function save():void
		{
			// get all properties in an XML object
			var xml:XML = toXML();
			
			// get the component instance the figure is displaying
			var comp:ComponentInstanceVO = _fig.getComponentInstance();
			
			// update its raw properties string
			comp.rawPropXML = xml.toXMLString();
		}
	
		/**
		 * Save component-specific properties to an XML object. 
		 * @param comp
		 * @param propXML
		 */	
		protected function saveComponentProperties(comp:IComponentPlugin, propXML:XML):void
		{
			// make sure PropertyField values are up to date
			comp.prepareValuesForSave();
			
			// cycle through each property and save it to XML
			// workflow is as follows:
			// if the property provides its own serialisation, we only need to create the envelope tag
			// otherwise, we use JSON to encode the property's propValue and then wrap it in a CDATA section
			var list:Array = comp.getSaveableProperties();
			var attrib:XMLList;
			var tag:XML;
			
			for each(var prop:IComponentProperty in list)
			{
				// create separate tag for it
				tag = <tag/>;
				tag.setName(prop.propName);
				
				if(prop.isFilePath())
					tag.@isPath = "true";
					
				// does the property provide its own serialisation?
				if(prop.hasOwnSerialiser())
				{
					prop.serialiseToXML(tag);
				}else{
					
					// use JSON to serialise
					PropertySerialiser.serialise(prop.propValue, tag);
				}
				
				// add to XML
				propXML.appendChild(tag);
			}
		}
		
		
		/**
		 * Apply component-specific settings stored in the figure component's raw properties XML. 
		 */		
		public function applyComponentSettings():void
		{
			// get the component (will only work if the figure's component has already loaded)
			var comp:IComponentPlugin = _fig.getContent() as IComponentPlugin;
			
			if(!comp)
				return;
				
			// get the raw property string
			var rawPropXML:String = _fig.getComponentInstance().rawPropXML;
			
			if(rawPropXML)
			{
				// convert to xml
				// there might conceivably be a parse error, so we wrap it in a try...catch block
				try{
					var xml:XML = new XML(rawPropXML);
		
					// we go through the property fields and try to find attributes for them
					// we then either use JSON to decode the values or pass them on to the properties themselves
					var list:Array = comp.getSaveableProperties();
					var attribs:XMLList;
					var stringValue:String;
						
					for each(var prop:IComponentProperty in list)
					{
						attribs = xml.child(prop.propName);
						
						if(attribs.length() > 0)
						{
							
							if(prop.hasOwnSerialiser())
							{
								prop.deserialiseFromXML(attribs[0] as XML);
								
							}else{
								
								// decode using JSON
								try{
									
									prop.propValue = PropertySerialiser.deserialise(attribs[0] as XML);
									
								}catch(e:Error){
								
									trace("FigureSerialiser::applyComponentSettings - FAILED to decode [", prop.propName, stringValue, "]");
								
								}
							}
						}
					}
				}catch(e:Error){}
			}
			
			// let the component know that its data has been updated
			comp.propertyValuesInitialised();
		}
		
		
		/**
		 * Position the figure (x, y, width, height) using the properties defined in its raw XML settings. 
		 */		
		public function positionFigure():void
		{
 			// convert to xml
			var xml:XML = new XML(_fig.getComponentInstance().rawPropXML);
			
			// if xml doesn't contain any properties, we don't apply the values
			var applyValues:Boolean = false;
			
			// x, y, width, height are assigned to the figure directly rather than the component
			// rather than set the values directly, we set them via the 'basic display box' to make sure the hotdraw figure updates correctly
			var origin:_Point = new _Point(0, 0);
			
			if(xml.hasOwnProperty("@x"))
			{
				origin.x = int(xml.@x);
				applyValues = true;
			}
				
			if(xml.hasOwnProperty("@y"))
			{
				origin.y = int(xml.@y);
				applyValues = true;
			}

			// bottom-right corner
			var corner:_Point = new _Point(origin.x, origin.y);
			
			if(xml.hasOwnProperty("@width"))
			{
				corner.x += int(xml.@width);
				applyValues = true;
			}	
			
			if(xml.hasOwnProperty("@height"))
			{
				corner.y += int(xml.@height);
				applyValues = true;
			}
				
			// apply
			if(applyValues)
				_fig.displayBox(origin, corner);
		}
		
		
		

	}
}