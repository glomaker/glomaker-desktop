package org.glomaker.plugin.dragdrop
{
	import com.hotdraw.java.awt.geom._Point;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.TextArea;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	
	public class DraggableItem extends SelfAdjustingTextArea
	{
		
		protected var _hotspotData:HotspotVO;
		
		public function DraggableItem()
		{
			super();
			editable = false;
			blendMode = BlendMode.LAYER;
			mouseChildren = false;
		}
		
		public function set hotspotData( value:HotspotVO ):void
		{
			_hotspotData = value;
			if( value )
			{
				text = value.text;
			}else{
				text = "";
			}
			trace("hotspot data", getStyle("fontSize"));
		}
		
		public function get hotspotData():HotspotVO
		{
			return _hotspotData;
		}
	}
}