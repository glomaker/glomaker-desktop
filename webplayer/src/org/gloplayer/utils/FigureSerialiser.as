package org.gloplayer.utils
{
	import flash.geom.Point;
	
	import org.glomaker.shared.component.interfaces.IComponentPlugin;
	import org.glomaker.shared.properties.FilePathField;
	import org.glomaker.shared.properties.PropertyField;
	import org.gloplayer.data.ComponentInstanceVO;
	import org.gloplayer.hotdraw.ComponentProxyFigure;
	
	
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
			var list:Array = comp.getProperties();
			var attrib:XMLList;
			var tag:XML;
			
			for each(var prop:PropertyField in list)
			{
				// create separate tag for it
				tag = <tag/>;
				tag.setName(prop.propName);
				
				if(prop is FilePathField)
					tag.@isPath = "true";
				
				tag.appendChild(prop.serialise());
				
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
			
			if(!rawPropXML)
				return;
			
			// convert to xml
			var xml:XML = new XML(rawPropXML);

			// we go through the property fields and try to find attributes for them
			var list:Array = comp.getProperties();
			var attribs:XMLList;
			var stringValue:String;
				
			for each(var prop:PropertyField in list)
			{
				attribs = xml.child(prop.propName);
				
				if(attribs.length() > 0)
				{
					// get first child - this stores the value of the property
					// eg. <text>Introduction to the Presentation</text>
					stringValue = XML(attribs[0]).text().toString();
					prop.deserialise(stringValue);
				}
			}
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
			var origin:Point = new Point(0, 0);
			
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
			var corner:Point = new Point(origin.x, origin.y);
			
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
			if(applyValues){
			 _fig.x = origin.x;
			 _fig.y = origin.y;
			 _fig.width = corner.x - origin.x;
			 _fig.height = corner.y - origin.y;
			}
		}

	}
}