/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.glomaker.patternmaker.utils.PatternMakerTextFormat;
	
	
	public class DescriptionNode extends InteractiveNode
	{
		// private var _rootNode:TextField;
		private var _textFormat:PatternMakerTextFormat;
		private var _titleText:TextField;
		private var _explainText:TextField;
		private var _bg:Sprite;
		private var _textW:uint;
		
		public function DescriptionNode(sqr:uint, c:uint)
		{
			super(sqr, c);
			
			_textFormat = new PatternMakerTextFormat();
			_textFormat.leftMargin = 10;
			_textFormat.rightMargin = 10;
			
			_textW = 220;

			addDescriptionFields();
		}
		
		private function addDescriptionFields():void
		{
			
			_bg = new Sprite();
			addChild(_bg);
			/* _rootNode = new TextField();
			_rootNode.autoSize = TextFieldAutoSize.RIGHT;
			_rootNode.x = node.x - (_rootNode.width + sqrSize / 2);
			
			addChild(_rootNode); */
			
			_titleText = new TextField();
			_titleText.name = "titleText";
			_titleText.width = _textW;
			_titleText.height = 20;
			_titleText.border = true;
			_titleText.type = TextFieldType.INPUT;

			_titleText.x = node.x + (sqrSize / 2) + 4;
			_titleText.y = node.y - (sqrSize / 2);
			_titleText.addEventListener(TextEvent.TEXT_INPUT, onTitleTextInput);
			_titleText.addEventListener(Event.CHANGE, onTitleTextInput);
			
			addChild(_titleText);
			
			_explainText = new TextField();	
			_explainText.name = "explainText";
			_explainText.width = _textW;
			//_explainText.autoSize = TextFieldAutoSize.LEFT;
			_explainText.border = true;
			_explainText.multiline = true;
			_explainText.wordWrap = true;
			_explainText.type = TextFieldType.INPUT;
			_explainText.x = node.x + (sqrSize / 2) + 4;
			_explainText.y = (node.y - (sqrSize / 2)) + _titleText.height + 3;
			_explainText.addEventListener(Event.CHANGE, onExplainTextInput);
			
			addChild(_explainText);
			
			_bg.x = _titleText.x;
			_bg.y = _titleText.y; 
			
			setBGHeight();
		}
		
		private function onTitleTextInput(e:*):void
		{
			setBGHeight();
			_textFormat.size = 14;
			_titleText.setTextFormat(_textFormat);

		}
		
		private function onExplainTextInput(e:Event):void
		{
			setBGHeight();
			_textFormat.size = 12;
			_explainText.setTextFormat(_textFormat);

		}
		
		private function setBGHeight():void
		{
			_titleText.height = _titleText.textHeight + 3;
			_explainText.height = _explainText.textHeight + 13;
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0xDDDDDD, 0.7)
			_bg.graphics.drawRect(0, 0, _titleText.width, _titleText.height + _explainText.height);
			_bg.graphics.endFill(); 
		}
		
		public function setRootNodeText(rootNodeText:String):void
		{
			// _rootNode.text = rootNodeText;
		}
		
		public function setTitleText(tText:String):void
		{
			_titleText.text = tText;
			_textFormat.size = 14;
			_titleText.setTextFormat(_textFormat);
			setBGHeight();
		}
		
		public function setExplainText(eText:String):void
		{
			_explainText.text = eText;
			_textFormat.size = 12;
			_explainText.setTextFormat(_textFormat);
			setBGHeight();
		}
		
		/**
		 * Enables or disables editing of the title. 
		 * @param editable
		 * 
		 */
		public function setTitleEditable(editable:Boolean):void
		{
			if(editable){
				_titleText.type = TextFieldType.INPUT;
				_titleText.selectable = true;
			}else{
				_titleText.selectable = false;
				_titleText.type = TextFieldType.DYNAMIC;
			}
		}
		
		/**
		 * Enables or disables editing of the explain area. 
		 * @param editable
		 * 
		 */
		public function setExplainEditable(editable:Boolean):void
		{
			if(editable){
				_explainText.selectable = true;
				_explainText.type = TextFieldType.INPUT;
			}else{
				_explainText.selectable = false;
				_explainText.type = TextFieldType.DYNAMIC;
			}
		}
		
		/**
		 * Remove event listeners. 
		 * 
		 */
		override public function cleanUp():void
		{
			super.cleanUp();
			
			_titleText.removeEventListener(TextEvent.TEXT_INPUT, onTitleTextInput);
			_titleText.removeEventListener(Event.CHANGE, onTitleTextInput);
			_explainText.removeEventListener(Event.CHANGE, onExplainTextInput);
		}
	}
}