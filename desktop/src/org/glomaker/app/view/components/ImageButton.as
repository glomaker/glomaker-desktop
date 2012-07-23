/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.components
{
	import flash.events.Event;
	
	import mx.controls.Button;
	import mx.controls.Image;

	public class ImageButton extends Button
	{
		
		protected var _img:Image;
		protected var _imgSource:String;
		
		/**
		 * 
		 */		
		override protected function createChildren():void
		{
			super.createChildren();
			
			// add image
			if(!_img)
			{
				_img = addChild(new Image()) as Image;
				
				// apply source url if already available
				if(_imgSource)
					source = _imgSource;
			}
		}


		/**
		 * Set the source url for the image displayed on the button. 
		 * @param value
		 */		
		public function set source(value:String):void
		{
			_imgSource = value;
			
			if(_img)
			{
				_img.addEventListener(Event.COMPLETE, onImageComplete);
				_img.source = _imgSource;
			}
		}


		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */				
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			// make sure image is on top of button skins and icons
			addChild(_img);
		}
		
		
		/**
		 * Event handler - image has finished loading. 
		 * @param evt
		 */		
		protected function onImageComplete(evt:Event):void
		{
			_img.removeEventListener(Event.COMPLETE, onImageComplete);
			
			// size to content size			
			_img.width = _img.contentWidth;
			_img.height = _img.contentHeight;
			
			// centre
			_img.x = (width - _img.width)/2;
			_img.y = (height - _img.height)/2;
		}
		
		
	}
}