/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.app.view.components
{
	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;

	/**
	 * Simple TileList extension that will allow a single button to be selected within the list.
	 * Assumes that list item renderers used with the list provide a 'selected' property to select/deselect them.
	 * 
	 * Compatible with the Flex Button class.
	 * If using a Button as the item renderer, make sure that 'toggle' is set to 'false'.
	 *   
	 * @author Nils
	 */
	public class SimpleToggleList extends List
	{
		
		/**
		 * Constructor 
		 */		
		public function SimpleToggleList()
		{
			allowMultipleSelection = false;
			allowDragSelection = false;
		}
		
		
		/**
		 * Multiple selections are not allowed - overridden so the stored value is always 'false' 
		 * @param value
		 */		
		override public function set allowMultipleSelection(value:Boolean):void
		{
			super.allowMultipleSelection = false;
		}

		/**
		 * Select a particular item.
		 * Overridden to select previously selected data items. 
		 * @param item
		 * @param shiftKey
		 * @param ctrlKey
		 * @param transition
		 * @return 
		 */		
		override protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean=true):Boolean
		{
			// if no item specified, just clear the entire selection
			if(!item)
			{
				clearSelected();
				return false;
			}

			// if the currently selected item was clicked again, we ignore the click
			if(item.data == selectedItem)
				return false;

			// clear current selection
			clearSelected();
			
			// let super-class handle the new selection process
			var wasSelected:Boolean = super.selectItem(item, shiftKey, ctrlKey, transition);
			
			// done
			return wasSelected;
		}
		
		
		override protected function drawItem(item:IListItemRenderer, selected:Boolean=false, highlighted:Boolean=false, caret:Boolean=false, transition:Boolean=false):void
		{
			super.drawItem(item, selected, highlighted, caret, transition);
			
			// update selection status
			// assumes item has a 'selected' property
			Object(item).selected = selected;
		}
		
		/**
		 * Only items that haven't already been selected can be selected again. 
		 * @param data
		 * @return 
		 */		
		override public function isItemSelectable(data:Object):Boolean
		{
			return !isItemSelected(data);
		}
		
	}
}