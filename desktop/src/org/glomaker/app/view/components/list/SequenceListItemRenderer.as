/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.components.list
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.Button;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.events.FlexEvent;
	
	import org.glomaker.common.vo.PageInstanceVO;

	public class SequenceListItemRenderer extends UIComponent implements IListItemRenderer, IDropInListItemRenderer
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		/**
		 * Event broadcast when the 'show me how' button is clicked.
		 * The event is set to bubble.
		 */		
		public static const GUIDANCE_CLICKED:String = "SequenceListItemRenderer.HelpClicked";

		// STYLE NAME DEFINITIONS
		public static const CONTENT_PADDING_LEFT_STYLENAME:String = "itemContentPaddingLeft";
		public static const CONTENT_PADDING_RIGHT_STYLENAME:String = "itemContentPaddingRight";
		public static const CONTENT_PADDING_TOP_STYLENAME:String = "itemContentPaddingTop";
		public static const CONTENT_PADDING_BOTTOM_STYLENAME:String = "itemContentPaddingBottom";
			

		public static const TITLE_PADDING_LEFT_STYLENAME:String = "itemTitlePaddingLeft";
		public static const TITLE_PADDING_RIGHT_STYLENAME:String = "itemTitlePaddingRight";
		public static const TITLE_PADDING_TOP_STYLENAME:String = "itemTitlePaddingTop";
		public static const TITLE_PADDING_BOTTOM_STYLENAME:String = "itemTitlePaddingBottom";

		public static const VERT_CONTENT_GAP_STYLENAME:String = "itemVertContentGap";
		public static const HORZ_ICON_GAP_STYLENAME:String = "itemHorzIconGap";
		public static const BUTTON_PADDING_TOP_STYLENAME:String = "itemButtonPaddingTop";


		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------

		protected var _contentPaddingLeft:Number = 18;
		protected var _contentPaddingRight:Number = 10;
		protected var _contentPaddingTop:Number = 13;
		protected var _contentPaddingBottom:Number = 19;
		
		protected var _titlePaddingLeft:Number = 18;
		protected var _titlePaddingRight:Number = 18;
		protected var _titlePaddingTop:Number = 8;
		protected var _titlePaddingBottom:Number = 8;

		protected var _vertContentGap:Number = 10;
		protected var _horzIconGap:Number = 7;
		protected var _buttonPaddingTop:Number = 20;
		
		protected var _baseListData:BaseListData;
		
		protected var _data:Object;
		protected var _owner:PedagogicalSequenceList;
		
		protected var _title:UITextField;
		protected var _description:UITextField;
		protected var _guidanceButton:Button;
		
		protected var _titleBg:Shape;
		protected var _bg:Shape;
		protected var _endLine:Shape;
		protected var _icon:SequenceItemIcon;
		
		protected var _stylesAssigned:Boolean = false;

		
		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------

		/**
		 * @constructor 
		 */
		public function SequenceListItemRenderer()
		{
			super();
		}
		
		
		// ------------------------------------------------------------------
		// IListItemRenderer IMPLEMENTATION
		// ------------------------------------------------------------------

		/**
		 *  The data to render or edit.
		 */
		public function get data():Object { return _data; }
		
		/**
		 *  @private
		 */
		public function set data(value:Object):void
		{
			// note: value passed in might be null (presumably if list.dataProvider = null)
			if(value && !(value is PageInstanceVO))
				throw new Error("Item renderer data must be a PageInstanceVO instance.");
			
			if(value != _data)
			{
				_data = value;
				dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
				
				if(_data)
				{
					var vo:PageInstanceVO = _data as PageInstanceVO;
				
					_title.text = vo.node.title;
					_icon.insetColour = vo.colour;
					_description.text = vo.node.description;
					
					var hasGuidance:Boolean = (vo.node.func.guidance && vo.node.func.guidance.length > 0);
					_guidanceButton.visible = hasGuidance;
				}
			}
		}

	
		// ------------------------------------------------------------------
		// IDropInListItemRenderer IMPLEMENTATION
		// ------------------------------------------------------------------
		
		
	    /**
	     *  Implements the <code>listData</code> property
	     *  using setter and getter methods. 
	     */
	    public function get listData():BaseListData { return _baseListData; }
	    
	    /**
	     *  @private
	     */
	    public function set listData(value:BaseListData):void
	    {
    		_baseListData = value;
    		
    		// under some circumstances, listData might be null (presumably when list.dataProvider = null)
    		if(_baseListData)
    		{
    			_owner = _baseListData.owner as PedagogicalSequenceList;

				// type check
	    		if(!_owner)
	    			throw new Error("Item renderer can only be used with PedagogicalSequenceList list component");

    		}else{
    			_owner = null;
    		}
    		
	    }
	    

		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------

		override protected function createChildren():void
		{
			super.createChildren();

			// graphical elements			
			_bg = new Shape();
			addChild(_bg);
			
			_titleBg = new Shape();
			addChild(_titleBg);

			_endLine = new Shape();
			addChild(_endLine);
			
			// icon next to the title
			_icon = new SequenceItemIcon();
			addChild(_icon);

			// label field to display name
			_title = createInFontContext(UITextField) as UITextField;
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.wordWrap = _title.multiline = true;
			addChild(_title);
			
			// longer description field
			_description = createInFontContext(UITextField) as UITextField;
			_description.autoSize = TextFieldAutoSize.LEFT;
			_description.wordWrap = _description.multiline = true;
			_description.percentWidth = 1;
			_description.textColor = 0x333333;
			
			// guidance button
			_guidanceButton = createInFontContext(Button) as Button;
			_guidanceButton.label = "Show me how";
			_guidanceButton.addEventListener(MouseEvent.CLICK, onGuidanceButtonClick, false, 0, true);

		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// grab style information
			if(!_stylesAssigned)
				assignStyleValues();
			
			// if no list owner present, we don't need to (and actually can't) update
			if(!_owner)
				return;
			
			// update selected / unselected item			
			var isSelected:Boolean = selected;
			var isHighlighted:Boolean = highlighted;
			
			updateLayout(unscaledWidth, unscaledHeight, isSelected, isHighlighted);
			remeasureHeight(isSelected, isHighlighted);
			drawGraphics(isSelected, isHighlighted);
		}
		
		protected function get selected():Boolean
		{
			return (_owner != null) && _owner.isItemSelected(_data);
		}
		
		protected function get highlighted():Boolean
		{
			return (_owner != null) && _owner.isItemHighlighted(_data);
		}
		
		protected function get showGuidance():Boolean
		{
			return (_owner != null) && _owner.showGuidance;
		}
		
		protected function get hasGuidance():Boolean
		{
			var vo:PageInstanceVO = _data as PageInstanceVO;
			return (vo.node.func.guidance && vo.node.func.guidance.length > 0);
		}
		
 		override public function setActualSize(w:Number, h:Number):void
		{
			super.setActualSize(w, h);
		}

		
		/**
		 * Update layout to reflect current width, height, selected and highlighted status.
		 * Assumes _owner property is set and not null. 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * @param selected
		 * @param highlighted
		 */		
		protected function updateLayout(unscaledWidth:Number, unscaledHeight:Number, selected:Boolean, highlighted:Boolean):void
		{
			// update child elements
			var availWidth:Number = unscaledWidth - _contentPaddingLeft - _contentPaddingRight;
			_description.width = availWidth;

			_guidanceButton.maxWidth = unscaledWidth;
			_guidanceButton.setActualSize(_guidanceButton.getExplicitOrMeasuredWidth(), _guidanceButton.getExplicitOrMeasuredHeight());
			
			// title positioning
			_title.x = _titlePaddingLeft + _icon.getExplicitOrMeasuredWidth() + _horzIconGap;
			_title.y = _titlePaddingTop;
			_title.width = unscaledWidth - _title.x - _titlePaddingRight;

			// icon positioning
			_icon.x = _titlePaddingLeft;
			_icon.y = Math.floor(getTitleHeight() - _icon.getExplicitOrMeasuredHeight())/2;
			
			// content show/hide
			if(selected && showGuidance)
			{
				// add additional child elements
				addChild(_description);
				
				if(hasGuidance)
					addChild(_guidanceButton);
				else if(_guidanceButton.parent){
					_guidanceButton.parent.removeChild(_guidanceButton);
				}
				
				// position them				
				_description.x = _contentPaddingLeft;
				_description.y = getTitleHeight() + _contentPaddingTop;

				_guidanceButton.x = _contentPaddingLeft;
				_guidanceButton.y = _description.y + _description.getExplicitOrMeasuredHeight() + _buttonPaddingTop;
				
			}else{

				// remove content elements				
				if(_guidanceButton.parent)
					removeChild(_guidanceButton);
					
				if(_description.parent)
					removeChild(_description);
			}
			
			// position end line
			_endLine.y = getRequiredHeight() - 1;
			
		}
		
		/**
		 * Remeasures the height required by the button.
		 * If the required height is different from the current height, the list is updated.
		 * Assumes that the _owner property is set and not null. 
		 * @param selected
		 * @param highlighted
		 */		
		protected function remeasureHeight(selected:Boolean, highlighted:Boolean):void
		{
			var requiredHeight:Number = getRequiredHeight();  
			
			if(height != requiredHeight)
			{
				height = requiredHeight;
				_owner.invalidateList();
			}
		}
		
		/**
		 * Draws graphical elements to match current width, height, selected and highlighted states.
		 * @param selected
		 * @param highlighted
		 */
		protected function drawGraphics(selected:Boolean, highlighted:Boolean):void
		{
			var w:Number = width;
			var h:Number = height;
			
			var g:Graphics = _endLine.graphics;
			g.clear();
			g.beginFill(0x999999);
			g.drawRect(0, 0, w, 1);
			g.endFill();
			
			g = _bg.graphics;
			g.clear();
			g.beginFill(0xd5d5d5);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g = _titleBg.graphics;
			g.clear();
			
			// choose appropriate colour for title background
			if(selected)
				g.beginFill(0x999999);
			else if(highlighted)
				g.beginFill(0xc6c6c6);
			else
				g.beginFill(0xf3f3f3);

			g.drawRect(0, 0, w, getTitleHeight());
			g.endFill();
		}
		
		/**
		 * Returns the total height occupied by the item's title. 
		 * @return 
		 */		
		protected function getTitleHeight():Number
		{
			return _titlePaddingTop + _title.getExplicitOrMeasuredHeight() + _titlePaddingBottom; 			
		}

		/**
		 * Returns the total height of the item including the full content height.
		 * Will only return accurate results if the layout has been adjusted to display the item's content. 
		 * @return 
		 */		
		protected function getOverallContentHeight():Number
		{
			var h:Number = _guidanceButton.y + _guidanceButton.getExplicitOrMeasuredHeight() + _contentPaddingBottom;
			return h;
		}
		
		/**
		 * Calculates required height based on the current layout.
		 * Assumes following order of elements: label, description, button
		 * @return 
		 */		
		protected function getRequiredHeight():Number
		{
			var h:Number;
			
			if(showGuidance && selected)
			{
				h = getOverallContentHeight();
			}else{
				h = getTitleHeight();
			}
			
			return h;
		}
		
		
		/**
		 * Event handler - the item's 'show guidance' button was clicked. 
		 * @param evt
		 */		
		protected function onGuidanceButtonClick(evt:MouseEvent):void
		{
			// prevent this event being treated as a list select event
			evt.stopImmediatePropagation();
			evt.stopPropagation();
			
			// notify
			dispatchEvent(new Event(GUIDANCE_CLICKED, true));
		}
		
		
		/**
		 * Converts style definitions to protected variables.
		 * If no style definition is found for a given name, the protected variable's current value is left unchanged.
		 * Also sets the '_stylesAssigned' property to true.
		 */		
		protected function assignStyleValues():void
		{
			_stylesAssigned = true;
			
			// cycle through styles and save them
			// existing default values will be preserved if no style found
			_contentPaddingLeft = getNumericStyleValue(CONTENT_PADDING_LEFT_STYLENAME, _contentPaddingLeft);
			_contentPaddingRight = getNumericStyleValue(CONTENT_PADDING_RIGHT_STYLENAME, _contentPaddingRight);
			_contentPaddingTop = getNumericStyleValue(CONTENT_PADDING_TOP_STYLENAME, _contentPaddingTop);
			_contentPaddingBottom = getNumericStyleValue(CONTENT_PADDING_BOTTOM_STYLENAME, _contentPaddingBottom);
			
			_titlePaddingLeft = getNumericStyleValue(TITLE_PADDING_LEFT_STYLENAME, _titlePaddingLeft);
			_titlePaddingRight = getNumericStyleValue(TITLE_PADDING_RIGHT_STYLENAME, _titlePaddingRight);
			_titlePaddingTop = getNumericStyleValue(TITLE_PADDING_TOP_STYLENAME, _titlePaddingTop);
			_titlePaddingBottom = getNumericStyleValue(TITLE_PADDING_BOTTOM_STYLENAME, _titlePaddingBottom);
	
			_vertContentGap = getNumericStyleValue(VERT_CONTENT_GAP_STYLENAME, _vertContentGap);
			_horzIconGap = getNumericStyleValue(HORZ_ICON_GAP_STYLENAME, _horzIconGap);
			_buttonPaddingTop = getNumericStyleValue(BUTTON_PADDING_TOP_STYLENAME, _buttonPaddingTop);
		}
		
		
		/**
		 * Returns a style value, if found, or the specified default value if style property not defined.
		 * The style's value is converted to a number before returning.  
		 * @param name
		 * @param defaultValue
		 * @return 
		 */		
		protected function getNumericStyleValue(name:String, defaultValue:Object):Number
		{
			var styleValue:Object = getStyle(name);
			if(!styleValue)
				styleValue = defaultValue;
				
			return styleValue as Number;
		}
	}
}