package org.glomaker.plugin.dragdrop
{
	/**
	 * Value object storing information about a hotspot. 
	 * @author Nils
	 */
	[Bindable]
	public class HotspotVO
	{
		public var text:String;
		public var x:Number;
		public var y:Number;
		public var w:Number;
		public var h:Number;
		
		public function HotspotVO( text:String, x:Number, y:Number, w:Number, h:Number):void
		{
			this.text = text;
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
		}
	}
}