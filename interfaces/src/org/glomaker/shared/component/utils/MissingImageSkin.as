/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.shared.component.utils
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.skins.ProgrammaticSkin;


	/**
	 * Provides a reusable 'missing image' skin for glomaker component plugins.
	 * Displays a light-grey background, together with 'No file selected' text.
	 * 
	 * Usage:
	 * Apply the following style to your Image or SWFLoader component:
	 * 	
	 * <mx:Style>
	 *  .missingImageStyle {
				broken-image-skin: ClassReference("org.glomaker.shared.component.utils.MissingImageSkin");
				broken-image-border-skin: ClassReference(null);
		}
	 * </mx:Style>
	 * 
	 * eg:
	 * <mx:Image styleName="missingImageStyle"/>
	 * <mx:SWFLoader styleName="missingImageStyle"/>
	 *  
	 * @author Nils
	 */
	public class MissingImageSkin extends ProgrammaticSkin
	{
		
		// ------------------------------------------------------------------
		// STATIC CLASS PROPERTIES
		// ------------------------------------------------------------------
		
		protected static const BG_COLOUR:uint = 0xf2f2f2;
		
		protected static const DEFAULT_WIDTH:Number = 100;
		protected static const DEFAULT_HEIGHT:Number = 100;

		[Embed(source="assets/broken_image.swf",symbol="BrokenImageShape")]
		protected static const BrokenImageAsset:Class;


		// ------------------------------------------------------------------
		// INSTANCE PROPERTIES
		// ------------------------------------------------------------------
		
		protected var _missingTextAsset:Sprite;

		// ------------------------------------------------------------------
		// CONSTRUCTOR
		// ------------------------------------------------------------------
		
		/**
		 * @constructor 
		 */		
		public function MissingImageSkin()
		{
			super();
			
			// we need to add event listeners to the parent
			// so check when the component has been added to a display list
			// note weak references used when adding listener to avoid memory leaks
			addEventListener(Event.ADDED, onAdded, false, 0, true);
		}
		
		
		// ------------------------------------------------------------------
		// UIComponent implementation
		// ------------------------------------------------------------------
		
		
		/**
		 * @inheritDoc 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// width/height often comes through as 0
			// in that case we try to grab the width/height off the parent (which is the item we are skinning)
			var w:Number = unscaledWidth;
			var h:Number = unscaledHeight;
			
			if(w == 0)
			{
				if(parent)
				{
					w = (UIComponent(parent).explicitWidth ? UIComponent(parent).explicitWidth : parent.width);
				}else{
					w = DEFAULT_WIDTH;
				}
			}
			
			if(h == 0)
			{
				if(parent)
				{
					h = (UIComponent(parent).explicitHeight ? UIComponent(parent).explicitHeight : parent.height);
				}else{
					h = DEFAULT_HEIGHT;
				}
			}
			
			// draw
			drawContents(w, h);
		}
		
		
		// ------------------------------------------------------------------
		// PROTECTED INSTANCE METHODS
		// ------------------------------------------------------------------
		
		/**
		 * Draw the content of the skin. 
		 * @param w Total width
		 * @param h Total height
		 */		
		protected function drawContents(w:Number, h:Number):void
		{
			// draw rectangle
			var g:Graphics = graphics;
			
			g.clear();
			g.beginFill(BG_COLOUR);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			// missing image text needs centering
			if(_missingTextAsset)
			{
				_missingTextAsset.x = Math.round((w - _missingTextAsset.width)/2); 
				_missingTextAsset.y = Math.round((h - _missingTextAsset.height)/2);
			}
		}


		// ------------------------------------------------------------------
		// EVENT LISTENERS
		// ------------------------------------------------------------------

		/**
		 * Event listener - component has been added to a parent container.
		 * The 'parent' property is now available and we can add event listeners to it. 
		 * @param evt
		 */
		protected function onAdded(evt:Event):void
		{
			// done with this event
			removeEventListener(Event.ADDED, onAdded);
			
			// add a 'missing file' image to the parent
			// that way, we can keep this as a SWF asset which will look good when resized
			_missingTextAsset = new BrokenImageAsset() as Sprite;
			parent.addChild(_missingTextAsset);
			
			// component needs to be redrawn when parent is resized
			UIComponent(parent).addEventListener(ResizeEvent.RESIZE, onParentResize, false, 0, true);
			
			// cleanup when skin is removed
			addEventListener(Event.REMOVED, onRemoved);
		}
		
		/**
		 * Event listener - the parent has been resized. 
		 * @param evt
		 */		
		protected function onParentResize(evt:ResizeEvent):void
		{
			// the Image/SWFLoader components don't automatically resize their broken image skin
			// so we handle that here manually
			if(parent)
				setActualSize(parent.width, parent.height);
		}
		
		protected function onRemoved(evt:Event):void
		{
			// cleanup - remove the resize event listener
			try{
				UIComponent(parent).removeEventListener(ResizeEvent.RESIZE, onParentResize);
			}catch(e:Error){}

			// cleanup - remove the 'missing file' text asset from the parent
			try{
				parent.removeChild(_missingTextAsset);
			}catch(e:Error){}
			
			_missingTextAsset = null;
		}
		
	}
}