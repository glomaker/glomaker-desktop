package org.glomaker.plugin.dragdrop
{
	import flash.display.BlendMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.TextArea;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	
	public class DraggableItem extends TextArea
	{
		
		public function DraggableItem()
		{
			super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			editable = false;
			wordWrap = true;
			selectable = false;
			mouseChildren = false;
			blendMode = BlendMode.LAYER; // for transparency handling
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
			validateNow();
			adjustSize();
		}
		
		protected function adjustSize():void
		{
			var newHeight:Number = 0;
			for(var i:uint = 0; i < textField.numLines ; i++ )
			{
				newHeight += textField.getLineMetrics( i ).height + 1;
			}
			height = newHeight + Number(getStyle("paddingTop")) + Number(getStyle("paddingBottom"));
		}

	}
}