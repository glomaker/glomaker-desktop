/////////////////////////////////////////////////////////////////////////
// Copyright (c) 2007-09 LTRI, London Metropolitan Uni. All rights reserved.
// An Open Source Release under the GPL v3 licence  (see http://www.gnu.org/licenses/).
// Authors: Tom Boyle, Nils Millahn, Musbah Sagar, Martin Agombar.
// See http://www.glomaker.org for full details
/////////////////////////////////////////////////////////////////////////

package org.glomaker.patternmaker.view
{
	import org.glomaker.patternmaker.events.*;
	
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.glomaker.patternmaker.events.MenuEvent;

	public class CustomContextMenu extends EventDispatcher {

		//VARIABLES
		private var myContextMenu:ContextMenu;

		//CONSTRUCTOR
		public function CustomContextMenu() {
			myContextMenu = new ContextMenu();
			addCustomMenuItems();
			removeDefaultItems();

			myContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, dispatchMenuSelect);
		}
		//FUNCTIONS
		private function addCustomMenuItems():void {
			var item1:ContextMenuItem = new ContextMenuItem("Extract Node");
			var item2:ContextMenuItem = new ContextMenuItem("Delete Node");
			var item3:ContextMenuItem = new ContextMenuItem("Delete All");
			// var item4:ContextMenuItem = new ContextMenuItem("Make Active Sequence");

			myContextMenu.customItems.push(item1);
			myContextMenu.customItems.push(item2);
			myContextMenu.customItems.push(item3);
			// myContextMenu.customItems.push(item4);

			item1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, dispatchMenuItemSelect1);
			item2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, dispatchMenuItemSelect2);
			item3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, dispatchMenuItemSelect3);
			// item4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, dispatchMenuItemSelect4);

		}
		private function dispatchMenuSelect(e:ContextMenuEvent):void {
			//Probably not needed
		}
		private function dispatchMenuItemSelect1(e:ContextMenuEvent):void {
			var menu:MenuEvent = new MenuEvent(e.contextMenuOwner.parent.name+"_Extract Node");
			this.dispatchEvent(menu);
		}
		private function dispatchMenuItemSelect2(e:ContextMenuEvent):void {
			var menu:MenuEvent = new MenuEvent(e.contextMenuOwner.parent.name+"_Delete Node");
			this.dispatchEvent(menu);
		}
		private function dispatchMenuItemSelect3(e:ContextMenuEvent):void {
			var menu:MenuEvent = new MenuEvent(e.contextMenuOwner.parent.name+"_Delete All");
			this.dispatchEvent(menu);
		}
		/* private function dispatchMenuItemSelect4(e:ContextMenuEvent):void {
			var menu:MenuEvent = new MenuEvent(e.contextMenuOwner.parent.name+"_Make Active Sequence");
			this.dispatchEvent(menu);
		} */
		private function removeDefaultItems():void {
			myContextMenu.hideBuiltInItems();
			//If items are needed, they can be turned on as below.
			//var defaultItems:ContextMenuBuiltInItems = myContextMenu.builtInItems;
			//defaultItems.print = true;
		}


		//PUBLIC

		//GETTER
		public function get getCustomMenu():ContextMenu {
			return myContextMenu;
		}
	}
}