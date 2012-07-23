/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.plugin.imagemagnifier
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.wheelerstreet.fig.panzoom.utils.ContentRectangle;
	
	import flash.geom.Rectangle;
	
	import org.glomaker.shared.properties.AbstractCustomProperty;

	public class ImageMagnifierDataProperty extends AbstractCustomProperty
	{

		public var contentRectangle:ContentRectangle;

		public function ImageMagnifierDataProperty(name:String, label:String=null, value:Object=null)
		{
			super(name, label, value);
		}
		
			override public function serialiseToXML(parentNode:XML):void{

		   var tag:XML = <contentRectangle x={JSON.encode(contentRectangle.x)} y={JSON.encode(contentRectangle.y)}  width={JSON.encode(contentRectangle.width)}  height={JSON.encode(contentRectangle.height)}></contentRectangle>;
		   parentNode.appendChild( tag );
		   
		} 
		
		override public function deserialiseFromXML(value:XML):void{
					
			var x:Number = JSON.decode(value.contentRectangle.@x) as Number;
			var y:Number = JSON.decode(value.contentRectangle.@y) as Number;
			var width:Number = JSON.decode(value.contentRectangle.@width) as Number;
			var height:Number = JSON.decode(value.contentRectangle.@height) as Number;
			
			contentRectangle = new ContentRectangle(x,y,width,height,new Rectangle());
								
		}
		
	}
}