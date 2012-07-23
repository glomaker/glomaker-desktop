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
	
	import mx.core.BitmapAsset;
	import mx.core.UIComponent;

	/**
	 * Draws the icons used in the pedagogical sequence list item renderer.
	 * You must set the 'insetColour' property for a coloured inset to be drawn.
	 * 
	 * @author Nils
	 */	
	public class SequenceItemIcon extends UIComponent
	{

		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------

		protected static var INSET_WIDTH:Number = 9;
		protected static var INSET_HEIGHT:Number = 8;
		protected static var INSET_X:Number = 1;
		protected static var INSET_Y:Number = 3;

		[Embed(source="../assets/skins/icons/sequence_item_icon.png")]
		protected static var ICON:Class;
		
		
		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		protected var _icon:BitmapAsset;
		protected var _inset:Shape;
		protected var _insetColour:uint;


		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------

		/**
		 * Sets/gets the colour to use for the rectangular colour inset.
		 * No inset is shown unless you specify a colour.
		 * @param rgb
		 */
		public function set insetColour(rgb:uint):void
		{
			if(rgb != _insetColour)
			{
				_insetColour = rgb;
				drawInset();
			}
		}
		public function get insetColour():uint
		{
			return _insetColour;
		}
		

		// ------------------------------------------------------------------
		// UIComponent OVERRIDES
		// ------------------------------------------------------------------

		/**
		 * @inheritDoc 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_icon = new ICON() as BitmapAsset;
			addChild(_icon);
			
			_inset = new Shape();
			_inset.x = INSET_X;
			_inset.y = INSET_Y;
			addChild(_inset);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function measure():void
		{
			measuredMinHeight = _icon.height;
			measuredHeight = measuredMinHeight;
			
			measuredWidth = _icon.width;
			measuredMinWidth = measuredWidth; 
		}
		

		// ------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------


		/**
		 * Draws the colour inset rectangle. 
		 */
		protected function drawInset():void
		{
			var g:Graphics = _inset.graphics;
			g.clear();
			g.beginFill(_insetColour);
			g.drawRect(0, 0, INSET_WIDTH, INSET_HEIGHT);
			g.endFill();
		}
		
	}
}