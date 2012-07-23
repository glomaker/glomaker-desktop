/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.components.list
{
	import flash.display.Sprite;
	
	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.mx_internal;


	/**
	 * List class used to display the pedagogical sequence in the editor/designer view.
	 * Should be used in conjunction with the SequenceListItemRenderer item renderer.
	 * 
	 * Provides support for showing guidance for each item.
	 * Removes the standard list selection and rollover indicators.
	 * Allows for variable row-height items.
	 * Fixes a scrolling bug when using variable height list items.
	 * 
	 * Drawbacks: When the list is scrolled and its height changes, the scrollbar is not always removed. It should however still be updated correctly, so no errors occur.
	 * 
	 * @author Nils
	 */
	public class PedagogicalSequenceList extends List
	{

		// ------------------------------------------------------------------
		// NAMESPACES
		// ------------------------------------------------------------------

		use namespace mx_internal;


		// ------------------------------------------------------------------
		// CLASS PROPERTIES
		// ------------------------------------------------------------------

		private var _showGuidance:Boolean = false;
		
		
		public function PedagogicalSequenceList()
		{
			super();
			variableRowHeight = true;
		}
		

		// ------------------------------------------------------------------
		// GETTER / SETTERS
		// ------------------------------------------------------------------
				
		/**
		 * Get/set the showGuidance value.
		 * If set to true, the selected list item will expand to show further information about the pedagogical function.
		 * @param value
		 */
		public function set showGuidance(value:Boolean):void
		{
			if(value != _showGuidance)
			{
				_showGuidance = value;
				updateList();
			}
		}
		public function get showGuidance():Boolean
		{
			return _showGuidance;
		}
		
		
		/**
		 * Forces a call to 'updateList()'.
		 * Redraws the entire list. 
		 */		
		public function forceListUpdate():void
		{
			updateList();
		}
		
		
		// ------------------------------------------------------------------
		// List OVERRIDES
		// ------------------------------------------------------------------


		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			// do nothing - indicator won't be drawn
		}
		
		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			// do nothing - indicator won't be drawn
		}

		/**
		 * Entire method overwritten although only a block of code was commented out.
	     * @private
	     */
	    override protected function configureScrollBars():void
	    {
	        var rowCount:int = listItems.length;
	        if (rowCount == 0) return;
	
			// ignore nonvisible rows off the top
			var yy:Number;
			var i:int;
			var n:int = listItems.length;
	        // if there is more than one row and it is a partial row we dont count it
	        while (rowCount > 1 && rowInfo[n - 1].y + rowInfo[n-1].height > listContent.height - listContent.bottomOffset)
			{
	            rowCount--;
				n--;
			}
	
	        // offset, when added to rowCount, is the index of the dataProvider
	        // item for that row.  IOW, row 10 in listItems is showing dataProvider
	        // item 10 + verticalScrollPosition - lockedRowCount - 1;
	        var offset:int = verticalScrollPosition - lockedRowCount - 1;
	        // don't count filler rows at the bottom either.
	        var fillerRows:int = 0;
	        // don't count filler rows at the bottom either.
	        while (rowCount && listItems[rowCount - 1].length == 0)
	        {
	            if (collection && rowCount + offset >= collection.length)
	            {
	                rowCount--;
	                ++fillerRows;
	            }
	            else
	                break;
	        }
	
	        // we have to scroll up.  We can't have filler rows unless the scrollPosition is 0
	        // We don't do the adjustment if a data effect is running, because that prevents
	        // a smooth effect. Effectively, we pin the scroll position while the effect is
	        // running.
	        
	        /*
	         * Taken out - will now allow for empty rows to show at the bottom of the list.
	        
	        if (verticalScrollPosition > 0 && fillerRows > 0 && !runningDataEffect)
	        {
	             if (adjustVerticalScrollPositionDownward(Math.max(rowCount, 1)))
	                return;
	        }
	         
	        */
	
			if (listContent.topOffset)
			{
				yy = Math.abs(listContent.topOffset);
				i = 0;
				while (rowInfo[i].y + rowInfo[i].height <= yy)
				{
					rowCount--;
					i++;
					if (i == rowCount)
						break;
				}
			}
	
	        var colCount:int = listItems[0].length;
	        var oldHorizontalScrollBar:Object = horizontalScrollBar;
	        var oldVerticalScrollBar:Object = verticalScrollBar;
	        var roundedWidth:int = Math.round(unscaledWidth);
	        var length:int = collection ? collection.length - lockedRowCount: 0;
	        var numRows:int = rowCount - lockedRowCount;
	
	        setScrollBarProperties((isNaN(_maxHorizontalScrollPosition)) ?
	                            Math.round(listContent.width) :
	                            Math.round(_maxHorizontalScrollPosition + roundedWidth),
	                            roundedWidth, length, numRows);
	        maxVerticalScrollPosition = Math.max(length - numRows, 0);
	    }

	}
}