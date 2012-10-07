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
		public function DraggableItem()
		{
			super();
			editable = false;
			selectable = false;
			blendMode = BlendMode.LAYER;
		}
	}
}