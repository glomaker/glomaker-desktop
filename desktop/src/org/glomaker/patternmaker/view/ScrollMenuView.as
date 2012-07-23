/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.glomaker.interfaces.pattern.IPatternFunction;
	import org.glomaker.interfaces.pattern.IPatternHeading;
	import org.glomaker.patternmaker.events.ModelEvent;
	import org.glomaker.patternmaker.model.IBaseModel;
	import org.glomaker.patternmaker.utils.PatternMakerTextFormat;
	
	public class ScrollMenuView extends MenuView{
		
		private var _menuHeight:uint;
		private var _scrollWindowHeight:uint;
		private var _textFormat:PatternMakerTextFormat;
		private var _headingFormat:PatternMakerTextFormat;
		
		public function ScrollMenuView(aModel:IBaseModel, aController:Object = null){
			super(aModel, aController);
			
			_textFormat = new PatternMakerTextFormat();
			_textFormat.leading = 0;
			_textFormat.size = 11;
			
			_headingFormat = new PatternMakerTextFormat();
			_headingFormat.bold = true;
			
			//
			menuWidth = 210;
			_menuHeight = 500;
			_scrollWindowHeight = 480;
		}
		private function onScroll(e:Object):void{
			var scrollP:uint = e.target.scrollPosition;
			// container.scrollRect = new Rectangle(0, scrollP, menuWidth, _scrollWindowHeight);
		}
		private function setMenuHeight():void{
			_menuHeight = container.height;
		}
		
		override internal function createMenuItems():void
		{
			clearMenu();
			var menuList:Array = (model as IBaseModel).getMenuList();
			
			addChild(container);
			
			var manifestXML:XML = (model as IBaseModel).getGLO_manifest();

			var heading:IPatternHeading;
			var func:IPatternFunction;

			var headingTxt:TextField;
			var divLine:Shape;
			var rect:Sprite = new Sprite();
			var nodeTxt:TextField = new TextField();

			var headingLineMargin:Number = 2;
			var headingNodePadding:Number = 10;
			var nodeSpacing:Number = 10;
			
			var offset:uint = 0;
			
			for each(heading in menuList)
			{
				// heading line over
				divLine = new Shape();
				divLine.graphics.beginFill(0x909090);
				divLine.graphics.drawRect(0, 0, menuWidth, 1);
				divLine.y = offset;
				container.addChild(divLine);
				
				// move on
				offset += headingLineMargin;
				
				// heading text
				headingTxt = new TextField();
				
				headingTxt.defaultTextFormat = _headingFormat;
				headingTxt.autoSize = TextFieldAutoSize.LEFT;
				headingTxt.multiline = headingTxt.wordWrap = false;
				headingTxt.selectable = false;
				headingTxt.text = heading.title;
				headingTxt.x = 3;
				headingTxt.y = offset;

				container.addChild(headingTxt);
				
				// move on
				offset += headingTxt.height;

				// heading line under
				divLine = new Shape();
				divLine.graphics.beginFill(0x909090);
				divLine.graphics.drawRect(0, 0, menuWidth, 1);
				divLine.y = offset;
				container.addChild(divLine);

				// move on
				offset += headingNodePadding;

				for each(func in heading.functions)
				{

					// node icon graphic
					rect = new Sprite();
					rect.graphics.lineStyle(1);
					rect.graphics.beginFill(heading.colour);
					rect.graphics.drawRect(0, 0, sqrSize, sqrSize);
					rect.graphics.endFill();
					
					rect.name = func.id;
					rect.buttonMode = true;

					rect.x = indent;
					rect.y = offset;
					rect.addEventListener(MouseEvent.MOUSE_DOWN, onMenuBtnDown);

					container.addChild(rect);

					// function node text field
					nodeTxt = new TextField();
					nodeTxt.x = sqrSize + 3 + indent;
					
					nodeTxt.defaultTextFormat = _textFormat;
					nodeTxt.autoSize = TextFieldAutoSize.LEFT;
					nodeTxt.multiline = true;
					nodeTxt.wordWrap = true;
					nodeTxt.selectable = false;
					nodeTxt.width = menuWidth - nodeTxt.x;
					nodeTxt.text = func.title;

					nodeTxt.y = rect.y + sqrSize/2 - nodeTxt.textHeight/2 - 2; // 2 pixel automatic padding on textfield

					container.addChild( nodeTxt );

					// move along (aim for uniform height between rect graphics but might cause problems if more than 2 lines of text)
					offset += sqrSize + nodeSpacing;
				}
				
				// adjust offset to show new heading starting
				offset += nodeSpacing;
			}
		}
		override public function update(e:ModelEvent = null):void {
			switch(e.message){
				case "parseXML":
					createMenuItems();
					setMenuHeight()
					break;
				case "onXMLLoaded":
					createMenuItems();
					setMenuHeight()
					break;
				case "buildInstance":
					createMenuItems();
					setMenuHeight()
					break;
			}
			
		}
		
	}
}